Shader "Unlit/aditiverough"
{
	Properties{
		  _Color("Tint", Color) = (0, 0, 0, 1)
		  _MainTex("Texture", 2D) = "white" {}
			_bnoise("bnoise", 2D) = "white" {}
			_stroke("stroke", 2D) = "white" {}
	
	}

		SubShader{
			 Tags  {"Queue" = "Transparent" "RenderType" = "Transparent" }
		LOD 100
		Blend One One
			Pass{
				 CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag


			#include "UnityCG.cginc"

				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _bnoise;
				sampler2D _stroke;
	
				fixed4 _Color;

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

				v2f vert(appdata v)
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
				fixed4 frag(v2f i) : SV_TARGET{
					float m = tex2D(_MainTex, i.uv).a;
				float2 un = i.screenPosition * float2(1.78, 1.);
				float bt = rd(_Time.x);
				un = mul(un, rot(bt*6.));
				un += float2(rd(_Time.x + 47.42), rd(_Time.x + 457.23));
				float tr = smoothstep(0.2, 0.8, lerp(tex2D(_stroke, un).x, lerp(tex2D(_stroke, un).z, tex2D(_stroke, un).y, step(0.5, rd(_Time.x + 475.23))), step(0.5, rd(_Time.x + 956.))));
				float tt = tex2D(_bnoise, i.screenPosition*2. - bt).x;

				float bm = pow(tt, tr*9.2);
				m =pow( ov(m*lerp(1.,tt,0.1), bm),0.8);
					return _Color*m;
				}

				ENDCG
			}
	}

}
