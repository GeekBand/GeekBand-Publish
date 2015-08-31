// Copyright � 2014 Intel Corporation. All rights reserved.
//
// WARRANTY DISCLAIMER
//
// THESE MATERIALS ARE PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL OR ITS
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
// OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THESE
// MATERIALS, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Intel Corporation is the author of the Materials, and requests that all
// problem reports or change requests be submitted to it directly


#pragma version(1)
#pragma rs java_package_name(com.geekband.alpha.renderscript.androidbasicrs)

int radiusHi;
int radiusLo;
int xTouchApply;
int yTouchApply;

const float4 gWhite = {1.f, 1.f, 1.f, 1.f};
const float3 channelWeights = {0.299f, 0.587f, 0.114f};

uchar4 __attribute__((kernel)) root(const uchar4 in, uint32_t x, uint32_t y)
{
    float4 f4 = rsUnpackColor8888(in);
    int xRel = x - xTouchApply;
    int yRel = y - yTouchApply;
    int polar = xRel*xRel + yRel*yRel;
    uchar4 out;
    
    if(polar > radiusHi || polar < radiusLo)
    {
        if(polar < radiusLo)
        {
            float3 outPixel = dot(f4.rgb, channelWeights);
            out = rsPackColorTo8888(outPixel);
        }
        else
        {
            out = in;
        }
    }
    else
    {
         out = rsPackColorTo8888(gWhite);
    }
    return out;
}