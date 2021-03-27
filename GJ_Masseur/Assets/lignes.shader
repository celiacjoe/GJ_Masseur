Shader "Unlit/lignes"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
         _Color("_Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        Tags  {"Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
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
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            float li(float2 uv, float2 a, float2 b) {
                float2 ua = uv - a; float2 ba = b - a;
                float h = clamp(dot(ua, ba) / dot(ba, ba), 0., 1.);
                return length(ua - ba * h);
            }
            float rd(float t) { return frac(sin(dot(floor(t), 45.)) * 4512.235); }
            float no(float t) { return lerp(rd(t), rd(t + 1.), smoothstep(0., 1., frac(t))); }
            fixed4 frag(v2f i) : SV_Target
            {
                float3 col = _Color.xyz;
                float t = tex2D(_MainTex, float2(0.,i.uv.y*0.3+_Time.x*10.)).x-0.5;
                float t2 = tex2D(_MainTex, float2(0.3, i.uv.y * 0.3 - _Time.x * 10.)).x-0.5;
                float t3 = tex2D(_MainTex, float2(0.6,  _Time.x * 10.)).x-0.5;
                float2 fac = float2(1.,  5.);
                float m = smoothstep(0.05,0.,li(i.uv*fac+float2(t,0.)*0.4+t3*0.2, float2(0.5, 0.1)*fac, float2(0.5, 0.95)*fac));
                m += smoothstep(0.05, 0., li(i.uv * fac + float2(t2, 0.) * 0.4-t3*0.2, float2(0.5, 0.1) * fac, float2(0.5, 0.95) * fac));
                
                return float4(col,m);
            }
            ENDCG
        }
    }
}
