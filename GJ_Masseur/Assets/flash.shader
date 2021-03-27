Shader "Unlit/flash"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _flash("_flash", Range(0,1)) = 0
            _mvt("_mvt", Range(0,1)) = 0
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
            float _flash;
            float _mvt;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            float2x2 rot(float t) { float c = cos(t); float s = sin(t); return float2x2(c, -s, s, c); }
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
            float4 c = tex2D(_MainTex, uv2*0.5+0.5);
            float3 c2 = pow(clamp(c - t1 * 0.1, 0., 1.), lerp(1., 20., smoothstep(0.2, 0.4, e)));
            float3 r1 = lerp(lerp(lerp(lerp(c2, 1. - c2, t1), c2, t2), 1. - c2, t3), c.xyz, t4);
            return float4(r1, 1.);
                //return col;
            }
            ENDCG
        }
    }
}
