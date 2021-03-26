Shader "Unlit/reglageDepth"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _s1("_s1",Range(0,1)) = 0
            _s2("_s2",Range(0,1)) = 0
            _s3("_s3",Range(0,1)) = 0
            _s4("_s4",Range(0,1)) = 0
            _s5("_s5",Range(0,1)) = 0
            _s6("_s6",Range(0,1)) = 0
            _rx1("_rx1",Range(0,1)) = 0
            _rx2("_rx2",Range(0,1)) = 0
            _ry1("_ry1",Range(0,1)) = 0
            _ry2("_ry2",Range(0,1)) = 0
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _s1;
            float _s2;
            float _s3;
            float _s4;
            float _s5;
            float _s6;
            float _rx1;
            float _rx2;
            float _ry1;
            float _ry2;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            float2 map(float2 value, float2 min1, float2 max1, float2 min2, float2 max2) {
                return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
            }
            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = 1. - i.uv;
                float2 uv2 = map(i.uv, float2(1., 1.), float2(0., 0.), float2(_rx1, _ry1), float2(_rx2, _ry2));
                float t1 = smoothstep(_s1, _s2, tex2D(_MainTex, uv2).x);
                float m1 = smoothstep(_s3, _s4, distance(i.uv, float2(0.5, 0.5)))*smoothstep(_s5,_s6,i.uv.y);
                fixed4 col = float4(t1,t1,t1,1.)*m1;
                return col;
            }
            ENDCG
        }
    }
}
