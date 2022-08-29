Shader "Unlit/time"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_bnoise("bnoise", 2D) = "white" {}
		_stroke("stroke", 2D) = "white" {}
		_timer("_timer", Range(0,1)) = 0
		_grad("grad", 2D) = "white" {}
    }
    SubShader
    {
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
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
			sampler2D _bnoise;
			sampler2D _stroke;
            float4 _MainTex_ST;
			float _timer;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.screenPosition = o.vertex;
                return o;
            }
			float rd(float uv) { return frac(sin(dot(floor(uv*80.), 45.236))*7845.236); }
			float2x2 rot(float t) { float c = cos(t); float s = sin(t); return float2x2(c, -s, s, c); }
			float ov(float base, float blend) {
				return base < 0.5 ? (2.0*base*blend) : (1.0 - 2.0*(1.0 - base)*(1.0 - blend));
			}
			float li(float2 uv, float2 a, float2 b) {
				float2 ua = uv - a; float2 ba = b - a;
				float h = clamp(dot(ua, ba) / dot(ba, ba), 0., 1.);
				return length(ua - ba * h);
			}
            fixed4 frag (v2f i) : SV_Target
            {
                
                fixed4 col = tex2D(_MainTex, i.uv);
			//float3 co = clamp(3.*abs(1. - 2.*frac(_Time.x*40. + float3(0., -1. / 3., 1. / 3.))) - 1., 0., 1.);
			float3 co = tex2D(_grad, float2(_Time.x*80., 0.)).xyz;
				float m = smoothstep(0.45, 0.4, distance(i.uv, float2(0.5, 0.5)));
				float2 uc = (i.uv - 0.5);
				float tmm = smoothstep(0., 1., _timer)*-6.28;
				uc = mul(uc, rot(tmm));
				float tm = 3.2*(_timer*0.5 );
				float2 ur = (atan2(uc.x, uc.y) / 3.14)*0.5 + 0.5;
				float m2 = smoothstep(tm,tm-_timer*2.,1.-(ur));
				float2 un = i.screenPosition * float2(1.78, 1.);
				float2 ul = (i.uv - 0.5)*2.;
				ul = mul(ul, rot(tmm));
				float t = tex2D(_MainTex, float2(0., i.uv.y*0.3 + _Time.x*10.)).x - 0.5;
				float t2 = tex2D(_MainTex, float2(0., i.uv.y*0.3 + _Time.x*10.+45.23)).x - 0.5;
				float la = smoothstep(0.05, 0.0, li(ul + float2(t, 0.)*0.2, float2(0., 0.), float2(0., -0.9)));

				float l2 = (smoothstep(0.015, 0.0, distance(0.45,length(uc + float2(t, 0.)*0.1)))+ smoothstep(0.015, 0.0, distance(0.45, length(uc + float2(t2, 0.)*0.1))))*0.7;

				float bt = rd(_Time.x);
				un = mul(un, rot(bt*6.));
				un += float2(rd(_Time.x + 47.42), rd(_Time.x + 457.23));
				float tr = smoothstep(0.2, 0.8, lerp(tex2D(_stroke, un).x, lerp(tex2D(_stroke, un).z, tex2D(_stroke, un).y, step(0.5, rd(_Time.x + 475.23))), step(0.5, rd(_Time.x + 956.))));
				float tt = tex2D(_bnoise, i.screenPosition*2. - bt).x;
				m2 = pow(ov(m2, lerp(0.5,pow(tt, tr),0.4)),1.-pow(_timer,8.));
				float bm = pow(tt, tr*10.);
				m = smoothstep(0.,1.,ov(m,bm));
				float m3 =  smoothstep(0., 1., ov(la+l2, bm))*smoothstep(0.,0.1,_timer);
                return max(float4(co,m*m2),m3*0.65);
            }
            ENDCG
        }
    }
}
