Shader "Unlit/resultatfinal"
{
    Properties
    {
        _MainTex ("_MainTex", 2D) = "white" {}
        _img1PosX("_img1PosX", Range(-1,1))= 0
        _img1PosY("_img1PosY", Range(-1,1)) = 0
        _img1Rot("_img1Rot", Range(-10,10)) = 0
        _img2PosX("_img2PosX", Range(-1,1)) = 0
        _img2PosY("_img2PosY", Range(-1,1)) = 0
             _img2Rot("_img2Rot", Range(-10,10)) = 0
        _img3PosX("_img3PosX", Range(-1,1)) = 0
        _img3PosY("_img3PosY", Range(-1,1)) = 0
             _img3Rot("_img3Rot", Range(-10,10)) = 0
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
            float4 _MainTex_ST;
            float  _img1PosX;
            float  _img1PosY;
            float  _img2PosX;
            float  _img2PosY;
            float  _img3PosX;
            float  _img3PosY;
            float _img1Rot;
            float _img2Rot;
            float _img3Rot;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            float2x2 rot(float t) { float c = cos(t); float s = sin(t); return float2x2(c, -s, s, c); }
            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = (i.uv - 0.5) * 2.;
                float2 uv1 = uv; float2 uv2 = uv; float2 uv3 = uv;
                uv1 = mul(uv1, rot(_img1Rot));
                uv2 = mul(uv2, rot(_img2Rot));
                uv3 = mul(uv3, rot(_img3Rot));
                float tr = tex2D(_MainTex, uv*0.5+0.5).r;
                float tg = tex2D(_MainTex, uv1 * 0.5 + 0.5 + float2(_img1PosX, _img1PosY)).g;
                float tb = tex2D(_MainTex, uv2 * 0.5 + 0.5 + float2(_img2PosX, _img2PosY)).b;
                float ta = tex2D(_MainTex, uv3 * 0.5 + 0.5 + float2(_img3PosX, _img3PosY)).a;
                float t1 = max(tr, max(tg,max( tb, ta)));
                return float4(t1,t1,t1,1.);
            }
            ENDCG
        }
    }
}
