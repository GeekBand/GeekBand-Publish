#pragma version(1)
#pragma rs java_package_name(com.geekband.alpha.renderscript)
#pragma rs_fp_relaxed

//input frame sizes
int imageWidth;
int imageHeight;
//input buffer (frame)
rs_allocation RGBABuffer;

//This is image-processing routine in Renderscipt that applies popular "Old Movie" effect to the input frames

// parameters for scratches and stains (like min and max values for the extents):
#define MIN_NOISE_W 8
#define MIN_NOISE_H 8
#define MAX_NOISE_W 24
#define MAX_NOISE_H 24
#define MIN_SCRATCH_LEN 8
#define MAX_SCRATCH_LEN 100

#define MAX_SCRATCH_FRAMES 3
#define MAX_STAIN_FRAMES 2
#define FRAMES_FLICKERING 3

// parameters for vertical scratches
//   min/max number of frames to display the vertical scratch
#define MIN_VERTICALSCRATCH_FRAMES 10
#define MAX_VERTICALSCRATCH_FRAMES 15
//   number of segments in the scratch (as it is modulated not as a straight line, but piecewise linearly approximation)
#define VERTICALSCRATCH_BUF_SIZE    8
// vertical scratch position jittering
#define VERTICALSCRATCH_DEV_X       4.0f
// vertical scratch intensity jittering
#define VERTICALSCRATCH_DEV_I       0.2f

#define MAX_SHAKE_FRAMES 10
#define SHAKE_FOR_FRAMES 3
#define MAX_SHAKE_CADENCE 24

//vignetting size, the value have to be less than 1
#define NORMALIZE_VIGNETTE_SIZE 0.3

// struct that holds the values for one scratch and a stain
typedef struct DefData_{
    //current frame number (used for evolution over time)
    //in the rest of code, the lifetime (a period for an effect to be applied) is measured in frames
    int             frame;
    //for how many frames emulate camera shakes
    int             timeToShake;
    //shake-factor for the current frame (in pixels)
    int             shift;
    // flickering factor (evolves over time)
    float intensity_flickering;
    //per-stain parameters
    struct
    {
        //coordinates
        int             x,y;
        //exstensions
        unsigned int    w,h;
        //time left (in frames)
        int             time;
        //mask (allocated for the maximum possible stain extents)
        float           mask[MAX_NOISE_H][MAX_NOISE_W];
    } stain;
    //per-scratch parameters
    struct
    {
        //coordinates
        float           x,y;
        //direction
        float           vx,vy;
        //length of the scratch
        float           len;
        //time left (in frames)
        int             time;
        //mask (allocated for the maximum possible scratch extent)
        float           D[MAX_SCRATCH_LEN];
    } scratch;
    //per-scratch parameters (for vertical scratch)
    struct
    {
        //coordinates of points that form the scratch (only X, as the scratches are vertical)
        float           x[VERTICALSCRATCH_BUF_SIZE];
        //intensity (a value per point)
        float           t[VERTICALSCRATCH_BUF_SIZE];
        //time left (in frames)
        int             time;
    } verticalScratch;
} DefData;

//static global data (so we have one scratch and one stain, change to array if you need more)
static DefData State;

//invoked once per frame (prior to applying the effect) to advance the effect's parameters over time
void update_state()
{
    int W = imageWidth;
    int H = imageHeight;

    int frame = ++State.frame;

    if(State.timeToShake>0 /*do we have to shake more?*/&& State.timeToShake < MAX_SHAKE_FRAMES /*shake for no more than 10 frames*/)
    {
        State.timeToShake--;
    }
    else
    {
        //enable the shakes from time to time (random)
        if(rsRand(MAX_SHAKE_CADENCE)==0) // e.g. with probability of 1/MAX_SHAKE_CADENCE we enable the camera shakes
        {
            //shake camera for MAX_SHAKE_FRAMES frames
            State.timeToShake=SHAKE_FOR_FRAMES;
        }
    }
    // shake-factor depending on the cuurent frame index (shake iteration)
    int shift = 0;
    if(State.timeToShake==1)
        shift = 20;
    if(State.timeToShake==2)
        shift = 16;
    if(State.timeToShake==3)
        shift = 24;
    State.shift=shift;

    // flickering factor (and how it evolves with frame number)
    State.intensity_flickering = 1+0.12f*(frame%FRAMES_FLICKERING);

    // a stain lives for a certian time, so decrease each frame
    State.stain.time--;
    //when a stain dies, regenretae another one
    if(State.stain.time<=0)
    {//generate new stain
        // time to show stain (1 or more frames)
        State.stain.time = 1+rsRand(MAX_STAIN_FRAMES);
        // width and height of stain (random, yet in the defined ranges)
        int w = State.stain.w = rsRand(MIN_NOISE_W, MAX_NOISE_W);
        int h = State.stain.h = rsRand(MIN_NOISE_H, MAX_NOISE_H);
        // random position of stain
        State.stain.x = rsRand((W)-w);
        State.stain.y = rsRand((H)-h);

        //generate mask of stain
#define RR rsRand(0.5f,1.7f)
        // distances to small circles
        float R[9] = {RR,RR,RR,RR,0,RR,RR,RR,RR};
        float fOneOverW = 1.f/w;
        float fOneOverH = 1.f/h;
        //fill the mask with 9 random (yet connected) points
        for(int yy=0;yy<h;yy++)for(int xx=0;xx<w;xx++)
        {// loop over all stain's mask pixels and set the mask (weight)
            float Weight = 1;
            float xf = 6*(xx+0.5f)*fOneOverH;
            float yf = 6*(yy+0.5f)*fOneOverW;
#define D2(_i,_x,_y)  if((xf-(3+(_x)*R[_i]))*(xf-(3+(_x)*R[_i]))+(yf-(3+(_y)*R[_i]))*(yf-(3+(_y)*R[_i]))<(1.2f*1.2f))Weight=0.4f;
            D2(0,-1,-1);D2(1,-1,+1);D2(2,+1,-1);
            D2(3,+1,+1);D2(4, 0,0); D2(5, 0,-1);
            D2(6, 0,+1);D2(7,-1,0); D2(8,+1,0);
            State.stain.mask[yy][xx] = Weight; // weight is transparency factor (1 by default, and 0.4f for the stains pixels defined by mask)
#undef D2
#undef RR
        }
    }

    State.scratch.time--;
    if(State.scratch.time<=0)
    {//generate another scratch
        // number of frames to disply the scratch
        State.scratch.time = 1+rsRand(MAX_SCRATCH_FRAMES);
        // random vector (scratch direction)
        float vx = rsRand(MAX_SCRATCH_LEN<<1)-MAX_SCRATCH_LEN;
        float vy = rsRand(MAX_SCRATCH_LEN<<1)-MAX_SCRATCH_LEN;
        // random position of the scratch
        State.scratch.x = (MAX_SCRATCH_LEN>>1)+rsRand(W-MAX_SCRATCH_LEN);
        State.scratch.y = (MAX_SCRATCH_LEN>>1)+rsRand(H-MAX_SCRATCH_LEN);
        float len =  sqrt(vx*vx+vy*vy)+0.000001f /*adding epsilon to avoid division by zero below*/;
        // normalized scratch direction
        State.scratch.vx = vx/len;
        State.scratch.vy = vy/len;
        // random length of the scratch (in the range)
        State.scratch.len = rsRand(MIN_SCRATCH_LEN, MAX_SCRATCH_LEN);
        int L = (int)State.scratch.len;
        // generate the curves of the scratches (with L segments)
        float   f = 0;
        for(int i=0;i<L;++i)
        {
            f = f+1+rsRand(-1.0f,1.0f);
            State.scratch.D[i] = 0.05f*L*cos(0.1f*f);
        }
    }
    State.verticalScratch.time--;
    // the scratch persists for some frames and with probability of 1/12 is updated
    if(State.verticalScratch.time<=0 && rsRand(12)==0)
    {//generate another vertical scratch
        // number of frames to display the scratch
        State.verticalScratch.time = rsRand(MAX_VERTICALSCRATCH_FRAMES,MAX_VERTICALSCRATCH_FRAMES);
        // random position of the scratch
        State.verticalScratch.x[0] = rsRand(imageWidth);
        // random intensity of the scratch
        State.verticalScratch.t[0] = rsRand(0.5f,1.0f);
        // populate the scratch parameters
        for(int i=1;i<VERTICALSCRATCH_BUF_SIZE;++i)
        {
            State.verticalScratch.x[i] = State.verticalScratch.x[i-1] + rsRand(-VERTICALSCRATCH_DEV_X,+VERTICALSCRATCH_DEV_X);
            State.verticalScratch.t[i] = 1.0f-rsRand(VERTICALSCRATCH_DEV_I);
        }
     }
     else
     {//update the vertical scratch (so it jitters and evolves)
        State.verticalScratch.x[0] = State.verticalScratch.x[VERTICALSCRATCH_BUF_SIZE-1];
        State.verticalScratch.t[0] = State.verticalScratch.t[VERTICALSCRATCH_BUF_SIZE-1];
        for(int i=1;i<VERTICALSCRATCH_BUF_SIZE;++i)
        {
            State.verticalScratch.x[i] = State.verticalScratch.x[i-1] + rsRand(-VERTICALSCRATCH_DEV_X,+VERTICALSCRATCH_DEV_X);
            State.verticalScratch.t[i] = 1.0f-rsRand(VERTICALSCRATCH_DEV_I);
        }
     }

}
const float normU8 = 1.f/255.f;
uchar4 __attribute__((kernel)) filter(const uchar4 in, uint32_t x, uint32_t y)
{
    uchar4  out;
    int frame = State.frame;
    // shifted y-coord of the pixel
    int ys = y-State.shift;
    uchar3  RGBA = *(uchar3*)rsGetElementAt(RGBABuffer, x, ys<0?(ys+imageHeight):ys);
    float3  fRGB;
    fRGB.r = RGBA[0]*normU8;
    fRGB.g = RGBA[1]*normU8;
    fRGB.b = RGBA[2]*normU8;
    //calculate the pixel intensity
    float   fYInp = (fRGB.r+fRGB.g+fRGB.b)/3;
    float   fY = fYInp;

    // increase contrast (to simulate the old films)
    fY = (fY-0.5f)*1.5f+0.5f;
    fY = clamp(fY,0.0f,1.0f);

    //check if still need appluy a stain
    if(State.stain.time>0)
    {//add noise stain
        unsigned int xl = (unsigned int)(x-State.stain.x);
        unsigned int yl = (unsigned int)(y-State.stain.y);
        //check if the pixel falls into the stain
        if(xl<State.stain.w && yl<State.stain.h)
        {
            fY *= State.stain.mask[yl][xl];
        }
    }

    //check if need to apply scratch
    if(State.scratch.time>0)
    {//add scratch
        float   dx = x-State.scratch.x;
        float   dy = y-State.scratch.y;
        float   tx = dx*State.scratch.vx + dy*State.scratch.vy;
        float   ty = dx*State.scratch.vy - dy*State.scratch.vx;
        //check if the pixel falls into the scratch
        if(tx>0 && tx<State.scratch.len)
        {
            float W = clamp(fabs(ty-State.scratch.D[(int)tx])*0.5f,0.4f,1.0f);
            fY *= W;
        }
    }
    //check if need to apply vertical scratch
    if(State.verticalScratch.time>0)
    {//add scratch
        float ty = (float)(VERTICALSCRATCH_BUF_SIZE-1)*(float)y/(float)(imageHeight);
        int   iy = (int)ty;
        float ry = ty-iy;
        float sx = State.verticalScratch.x[iy]*(1-ry)+State.verticalScratch.x[iy+1]*ry;
        float st = State.verticalScratch.t[iy]*(1-ry)+State.verticalScratch.t[iy+1]*ry;
        float dx = x-sx;
        float W = clamp(fabs(dx),0.0f,1.0f);
        fY = st-(st-fY)*W;
    }

    // adding vignette
    {
        //normalized difference from the image center
        float Scale = NORMALIZE_VIGNETTE_SIZE/(1-NORMALIZE_VIGNETTE_SIZE);
        float dx = (1.0f+Scale)*(x - imageWidth*0.5f)/(imageWidth*0.5f);
        float dy = (1.0f+Scale)*(y - imageHeight*0.5f)/(imageHeight*0.5f);
        dx *= dx;dy*=dy;
        dx *= dx;dy*=dy;
        dx *= dx;dy*=dy;
        //attenuation factor (depends on the distance from the image center)
        float d = 1+(1-sqrt(sqrt(sqrt(dx+dy))))/Scale;
        fY *= clamp(d,0.0f,1.0f);
    }


    //add intensity flickering (over FRAMES_FLICKERING frames)
    fY *= State.intensity_flickering;

    if(fYInp>0.25)//dark pixels has noisly color and are not used to colorise
    {
        // modulate
        fRGB *= fY/fYInp;
        //add color
        fRGB = 0.2f*fRGB + 0.8f*(float3)fY;
    }
    else
    {
        fRGB = (float3)fY;
    }

    return rsPackColorTo8888(fRGB);
}