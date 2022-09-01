Shader "Unlit/leap"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_bnoise("bnoise", 2D) = "white" {}
		_noise("noise", 2D) = "white" {}
			_stroke("stroke", 2D) = "white" {}
			_grad("grad", 2D) = "white" {}

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
				float4 screenPosition : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
			sampler2D _noise;
			sampler2D _bnoise;
			sampler2D _stroke;
			sampler2D _grad;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.screenPosition = o.vertex;
                return o;
            }
			float2x2 rot(float t) { float c = cos(t); float s = sin(t); return float2x2(c, -s, s, c); }
			float rn(float t) { return frac(sin(dot(floor(t), 45.)) * 4512.235); }
			float no(float t) { return lerp(rn(t), rn(t + 1.), smoothstep(0., 1., frac(t))); }
			float ov(float base, float blend) {
				return base < 0.5 ? (2.0*base*blend) : (1.0 - 2.0*(1.0 - base)*(1.0 - blend));
			}
			float hs(float2 uv, float t) { return frac(sin(dot(uv, float2(45.95, 78.14)))*7845.236 + t); }
			float rd(float uv) { return frac(sin(dot(floor(uv*80.), 45.236))*7845.236); }
            fixed4 frag (v2f i) : SV_Target
            {
			float2 um = (i.uv - 0.5)*2.5;
			float2 ud = 1.-pow(length(um),2.);
			um.y += -0.3;
			float uc = atan2(um.x+0.1, um.y-0.35);
			
			float2 um2 = mul(um, rot(0.1*sin(_Time.y*2.)))*0.5 + 0.5;
			float2 um3 = um2;
			float2 tt2 = (tex2D(_noise, float2(uc*0.1, _Time.y)).xy - 0.5)*0.05;
			um2 += tt2.x ;
			um3 += tt2.y;
			float c1 = tex2D(_MainTex, um2+float2(-0.02,-0.1)).x+ tex2D(_MainTex, um3 + float2(-0.02, -0.1)).x;
			
			float ti = floor(_Time.y*20.)*0.05;
			float pf = pow(lerp(frac(ti), 1. - frac(ti), step(0.5, frac(ti*0.5))), 2.)+0.3;
			um.y += pf*0.7;
			um = mul(um, rot(0.3*sin(pf*10.)));
			float uc2 = atan2(um.x , um.y );
			float2 tt3 = (tex2D(_noise, float2(uc2*0.2, _Time.y)).xy - 0.5)*0.05;
			float2 um4 = um;
			um += tt3.x;
			um4 += tt3.y;
			float tz = sin(um.y*1.5+ti*7.)*0.2*length(ud.y);
			um.x +=tz;
			um4.x +=tz ;

			um = um * 0.5 + 0.5;			
			float c2 =1.- tex2D(_MainTex,um).z;
			float c3 = tex2D(_MainTex, um).y+ tex2D(_MainTex, um4*0.5+0.5).y;

			float r = max(c1 * c2,c3);

			float2 un = i.screenPosition * float2(1.78, 1.);
			float bt = rd(_Time.x);
			un = mul(un, rot(bt*6.));
			un += float2(rd(_Time.x + 47.42), rd(_Time.x + 457.23));
			float tr = smoothstep(0.1, 0.85, lerp(tex2D(_stroke, un).x, lerp(tex2D(_stroke, un).z, tex2D(_stroke, un).y, step(0.5, rd(_Time.x + 475.23))), step(0.5, rd(_Time.x + 956.))));

			r = ov(r*0.7, pow(tex2D(_bnoise, i.screenPosition*2. - _Time.x*10.).x, tr*10.));


			float3 col = pow(tex2D(_grad, float2(_Time.x*80., 0.)).xyz, 0.25);
			return float4(col*r, 1.);
            }
            ENDCG
        }
    }
}
