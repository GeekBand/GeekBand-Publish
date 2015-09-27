#pragma version(1)
#pragma rs java_package_name(com.geekband.alpha.renderscript)
#define signalCost(x1,x2) ( (x1) > (x2) ? ( x1 - x2 ) : ( x2 - x1 ) )
#define int32_min(x1,x2) ((x1) > (x2) ? (x2) : (x1))

int32_t s1len = 0;
int32_t s2len = 0;
int32_t *d0;
int32_t *d1;
int32_t *r;
int16_t *signal1;
int16_t *signal2;

void dtw() {
		int32_t s = 0;
		rsDebug( "s1len",s1len);
		rsDebug( "s2len",s2len);
		for( int32_t x = 0 ; x < s1len ; ++x ) {
			s += signalCost((int32_t)signal1[x],(int32_t)signal2[0]);
			d0[x] = s;
		}
		s = 0;
		for( int32_t y = 1 ; y < s2len ; ++y ) {
			s += signalCost((int32_t)signal1[0],(int32_t)signal2[y]);
			d1[0] = s;
			int32_t *d0p = d0 + 1;
			int32_t *d1p = d1 + 1;
			for( int32_t x = 1 ; x < s1len ; ++x ) {
				int s1 = (int32_t)signal1[x];
				int s2 = (int32_t)signal2[y];
				int cs = signalCost( s1,s2);
				int32_t m =
					int32_min(
						d0p[-1],
						d1p[-1] );
				m = int32_min( m, *d0p );
				*d1p = cs+m;
				++d0p;
				++d1p;
			}
			int32_t *dp = d0;
			int32_t *sp = d1;
			int s1lend8 = s1len / 8;
			int s1lenm8 = s1len % 8;
			for( int32_t x = 0 ; x < s1lend8 ; ++x ) {
				*dp++ = *sp++;
				*dp++ = *sp++;
				*dp++ = *sp++;
				*dp++ = *sp++;
				*dp++ = *sp++;
				*dp++ = *sp++;
				*dp++ = *sp++;
				*dp++ = *sp++;
			}
			for( int32_t x = 0 ; x < s1lenm8 ; ++x )
				*dp++ = *sp++;
		}
		rsDebug( "maxCost", d1[s1len-1] );
		*r = d1[s1len-1];
}

