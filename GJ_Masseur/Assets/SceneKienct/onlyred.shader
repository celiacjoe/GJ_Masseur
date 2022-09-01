Shader "Unlit/onlyred"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_noise("noise", 2D) = "white" {}
		_noise2("noise2", 2D) = "white" {}
		_grad("grad", 2D) = "white" {}
		_f1("_f1", Range(0,1)) = 0
		_f2("_f2", Range(-1,1)) = 0
		_f3("_f3", Range(0,1)) = 0
		_f4("_f4", Range(0,1)) = 0
		_f5("_f5", Range(0,1)) = 0
		_f6("_f6", Range(0,1)) = 0
		_bnoise("bnoise", 2D) = "white" {}
		_stroke("stroke", 2D) = "white" {}
			/*_rx1("_rx1", Range(-1,1)) = 0
			_rx2("_rx2", Range(-1,1)) = 0
			_ry1("_ry1", Range(-1,1)) = 0
			_ry2("_ry2", Range(-1,1)) = 0*/
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float4 screenPosition : TEXCOORD1;
            };

            sampler2D _MainTex;
			sampler2D _grad;
			sampler2D _noise;
			sampler2D _noise2;
			sampler2D _bnoise;
			sampler2D _stroke;
            float4 _MainTex_ST;
			float _f1;
			float _f2;
			float _f3;
			float _f4;
			/*loat _rx1;
			float _rx2;
			float _ry1;
			float _ry2;*/
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.screenPosition = o.vertex;
                return o;
            }
			float rd(float uv) { return frac(sin(dot(floor(uv*80.), 45.236))*7845.236); }
			float2 map(float2 value, float2 min1, float2 max1, float2 min2, float2 max2) {
				return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
			}
			float ov(float base, float blend) {
				return base < 0.5 ? (2.0*base*blend) : (1.0 - 2.0*(1.0 - base)*(1.0 - blend));
			}
			float hs(float2 uv, float t) { return frac(sin(dot(uv, float2(45.95, 78.14)))*7845.236 + t); }

			float2x2 rot(float t) { float c = cos(t); float s = sin(t); return float2x2(c, -s, s, c); }
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
			float b = sqrt(100.);
			float d0 = 0.;
			//float2 uv2 =( map(i.uv, float2(1., 1.), float2(0., 0.), float2(_rx1, _ry1), float2(_rx2, _ry2))-0.5)*2.;
			float2 u2 = (i.uv-0.5)*2.;
			u2.x += _f2;
			float uc = atan2(u2.x, -u2.y)/3.14;
			//u2 *= 0.8;
			
			//float m1 = tex2D(_noise, float2(uc*0.5, _Time.x*10.)).x - 0.5;

			/*u2 = u2 * 0.5 + 0.5;

			u2 += m1 * 0.025;
			for (float k = -0.5*b; k <= 0.5*b; k += 1.)
				for (float j = -0.5 * b; j <= 0.5 * b; j += 1.) {
					d0 += tex2D(_MainTex, u2 + float2(k, j)*0.05*_f1 ).x;
				}*/
			//float z1 = rd(_Time.x);
			float2 m2 =tex2D(_noise, float2(uc*2., _Time.x*40.+458.36)).xy*0.5+ smoothstep(0., 1., tex2D(_noise2, float2(uc*0.5, _Time.x*20. + 458.36)).xy);
			//float pp = rd(_Time.x);
			//float zo =smoothstep(0.15,0.1,distance(abs(uc),lerp(pp,1.-pp,sign(uc)*0.5+0.5)));
			float zo = max(step(0.5, frac(uc*lerp(10.,25.,rd(_Time.x*0.1))+rd(_Time.x*3.))),step(0.8,rd(_Time.x*0.5)))*smoothstep(0.45,0.55,tex2D(_noise,float2(_Time.x*10.,_Time.x*0.01)).x);
			//float l1 = max(smoothstep(15.,0.,distance(d0, 15.)), smoothstep(15., 0., distance(d0, 15. + m2 * 50.)))*zo;
			float da = tex2D(_MainTex, i.uv).a;
			float la = smoothstep(0.05, 0., distance(da, 0.1 + m2.y * 0.2))*0.5;
			float lb = smoothstep(0.05, 0., distance(da, 0.1 + m2.x * 0.2))*0.5;
			float l1 = la + lb+max(la,lb) ;
			float3 bc = tex2D(_grad, float2(_Time.x*80. + 0.5, 0.)).xyz;
			   float3 co = pow(bc,0.2);
			   float3 co2 = pow(bc, 0.1);

			   float2 un = i.screenPosition * float2(1.78, 1.);
			   float bt = rd(_Time.x);
			   un = mul(un, rot(bt*6.));
			   un += float2(rd(_Time.x + 47.42), rd(_Time.x + 457.23));
			   float tr = smoothstep(0.1, 0.85, lerp(tex2D(_stroke, un).x, lerp(tex2D(_stroke, un).z, tex2D(_stroke, un).y, step(0.5, rd(_Time.x + 475.23))), step(0.5, rd(_Time.x + 956.))));

			   l1 = smoothstep(0.,1., ov(l1*_f3, pow(tex2D(_bnoise, i.screenPosition*2. - _Time.x*10.).x, tr*_f4*40.)))*zo;
			   float tt = tex2D(_bnoise, i.screenPosition*2. - bt).x;
			   float bcc = col.x;
			    bcc =ov(bcc, lerp(0.5, pow(tt, tr), 0.4));
                return float4(bcc*co+l1*co2,1.);
			   //return float4 (da, da, da, 1.);
            }
            ENDCG
        }
    }
}
