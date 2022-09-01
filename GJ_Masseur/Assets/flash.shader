Shader "Unlit/flash"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_screen("screen", 2D) = "white" {}
	    _noise("noise", 2D) = "white" {}
		_bnoise("bnoise", 2D) = "white" {}
        _flash("_flash", Range(0,1)) = 0
        _mvt("_mvt", Range(0,1)) = 0
			_f1("_f1", Range(0,1)) = 0
			_f2("_f2", Range(0,1)) = 0
			_f3("_f3", Range(0,1)) = 0
			_f4("_f4", Range(0,1)) = 0
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
            };

            sampler2D _MainTex;
			sampler2D _noise;
			sampler2D _bnoise;
			sampler2D _screen;
            float4 _MainTex_ST;
            float _flash;
			float _f1;
			float _f2;
			float _f3;
			float _f4;
            float _mvt;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            float2x2 rot(float t) { float c = cos(t); float s = sin(t); return float2x2(c, -s, s, c); }
			float hs(float2 uv,float t) { return frac(sin(dot(uv, float2(45.95, 78.14)))*7845.236+t); }
			float rd(float uv) { return frac(sin(dot(floor(uv*80.), 45.236))*7845.236 ); }
			float tt(float2 uv){
				float3 ta = tex2D(_MainTex, uv).xyz;
				return max(ta.x, max(ta.y, ta.z));
			}
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
            //    fixed4 col = tex2D(_MainTex, i.uv);
            float e = _flash;
            float t1 = smoothstep(0., 0.05, e);
            float t2 = smoothstep(0.05, 0.1, e);
            float t3 = smoothstep(0.1, 0.4, e);
            float t4 = smoothstep(0.4, 0.5, e);
            float t5 = smoothstep(0., 1., e);
            float2 uv = i.uv;
            float2 uc = (uv - 0.5);
            uv += uc * lerp(lerp(lerp(lerp(0., -0.1, t1), 0.1, t2), -0.2, t3), 0., t4) * lerp(0.25, 1.5, (distance(uv, float2(0.5, 0.5))));
            float d1 = smoothstep(t5, t5 - 0.5, distance(uv.x, 0.5)) * smoothstep(t5, t5 - 0.5, distance(uv.y, 0.5));
            float d2 = smoothstep(t5, t5 - 0.5, distance(uv.x + 0.1, 0.5)) * smoothstep(t5, t5 - 0.5, distance(uv.y, 0.5));
            float d3 = smoothstep(t5, t5 - 0.5, distance(uv.x, 0.5)) * smoothstep(t5, t5 - 0.5, distance(uv.y + 0.1, 0.5));
            float2 d4 = float2(d1 - d2, d1 - d3) * 0.2;
            uv += d4;
            uv.y += sin(uv.x * 10. + _Time.x*50.)*0.1*_mvt;
            float2 uv2 = (uv - 0.5) * 2.;
            uv2 = mul(uv2, rot(sin(_Time.x * 30.) * _mvt*0.05) );
			float2 un = i.uv * float2(1.78, 1.);
			float bt = rd(_Time.x);
			un = mul(un, rot(bt*6.));
			un += float2(rd(_Time.x+47.42), rd(_Time.x+457.23));
            float4 c = tex2D(_MainTex, uv2*0.5+0.5);
            float3 c2 = pow(clamp(c - t1 * 0.1, 0., 1.), lerp(1., 20., smoothstep(0.2, 0.4, e)));
            float3 r1 = lerp(lerp(lerp(lerp(c2, 1. - c2, t1), c2, t2), 1. - c2, t3), c.xyz, t4);
			float tr = lerp(tex2D(_noise, un).x, lerp(tex2D(_noise, un).z, tex2D(_noise, un).y,step(0.5,rd(_Time.x+475.23 ))),step(0.5,rd(_Time.x+956.)) );
			float h = tex2D(_bnoise, un*5.).x;
			float h2 = hs(i.uv, bt + _Time.x);
			float3 br = smoothstep(0.,1.,pow(h*_f1, lerp(10.*_f2, 200.*lerp(0.2,0.7, tex2D(_bnoise, float2(_Time.x,0.)).x), pow(tr, _f4*5.))))*pow(tex2D(_noise, un).xyz, 0.2);
			float3 r2 = lerp(r1, 1. - r1, br);
			/*float b = sqrt(128.);
			float d0 = 0.;
			for (float k = -0.5*b; k <= 0.5*b; k += 1.)
				for (float j = -0.5 * b; j <= 0.5 * b; j += 1.) {
					d0 += tt(i.uv + float2(k, j)*0.01*_f3 );
				}
			d0 /= 128.;*/

            return float4(max(r2,tex2D(_screen,i.uv).x), 1.);
            
            }
            ENDCG
        }
    }
}
