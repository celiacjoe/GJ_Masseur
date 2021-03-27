Shader "Hidden/Custom/effet01"
{
    HLSLINCLUDE

#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
    float _effet;
    float _distance;
    sampler2D _noise;
    float4 Frag(VaryingsDefault i) : SV_Target
    {
        
        float e = _effet;
        float t1 = smoothstep(0., 0.1, e);
        float t2 = smoothstep(0.1, 0.2, e);
        float t3 = smoothstep(0.2, 0.4, e);
        float t4 = smoothstep(0.4, 0.5, e);
        float2 uv = i.texcoord;
        float2 uc = (uv - 0.5);
        uv += uc * lerp(lerp(lerp(lerp(0.,-0.1,t1),0.1,t2),-0.2,t3),0.,t4)*lerp(0.25,1.5,(distance(uv,float2(0.5,0.5))));
        float d1 = smoothstep(e, e+0.5, distance(uv.x, 0.5));
        float4 c = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
        float3 c2 = pow(clamp(c-t1*0.1,0.,1.), lerp(1., 20., smoothstep(0.2, 0.4, e)));
        float3 r1 = lerp(lerp(lerp(lerp(c2, 1. - c2, t1),c2, t2),1.-c2, t3),c.xyz,t4);
        return float4(d1,d1,d1,1.);
    }

        ENDHLSL

        SubShader
    {
        Cull Off ZWrite Off ZTest Always

            Pass
        {
            HLSLPROGRAM

                #pragma vertex VertDefault
                #pragma fragment Frag

            ENDHLSL
        }
    }
}