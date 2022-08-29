﻿Shader "Unlit/time"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_timer("_timer", Range(0,1)) = 0
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _timer;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
			float2x2 rot(float t) { float c = cos(t); float s = sin(t); return float2x2(c, -s, s, c); }
            fixed4 frag (v2f i) : SV_Target
            {
                
                fixed4 col = tex2D(_MainTex, i.uv);
			float3 co = clamp(3.*abs(1. - 2.*frac(_Time.x*40. + float3(0., -1. / 3., 1. / 3.))) - 1., 0., 1.);
				float m = smoothstep(0.5, 0.49, distance(i.uv, float2(0.5, 0.5)));
				float2 uc = (i.uv - 0.5);
				uc = mul(uc, rot(smoothstep(0.,1.,_timer)*-6.28));
				float tm = 3.2*(_timer*0.5 );
				float m2 = smoothstep(tm,tm-0.5,1.-((atan2(uc.x, uc.y)/3.14)*0.5+0.5));
                return float4(co,m2*m);
            }
            ENDCG
        }
    }
}
