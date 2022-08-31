Shader "Unlit/onlyred"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_noise("noise", 2D) = "white" {}
		_grad("grad", 2D) = "white" {}
		_f1("_f1", Range(0,1)) = 0
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
			sampler2D _grad;
			sampler2D _noise;
            float4 _MainTex_ST;
			float _f1;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
			float rd(float uv) { return frac(sin(dot(floor(uv*80.), 45.236))*7845.236); }
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
			float b = sqrt(100.);
			float d0 = 0.;
			float2 u2 = (i.uv-0.5)*2.;
			float uc = atan2(u2.x, u2.y)/3.14;
			u2 *= 0.8;
			u2 = u2 * 0.5 + 0.5;
			for (float k = -0.5*b; k <= 0.5*b; k += 1.)
				for (float j = -0.5 * b; j <= 0.5 * b; j += 1.) {
					d0 += tex2D(_MainTex, u2 + float2(k, j)*0.05*_f1 ).x;
				}
			float z1 = rd(_Time.x);
			float m1 = tex2D(_noise, float2(uc*2.,_Time.x*10.)).x-0.5;
			float l1 = smoothstep(0.5,0.,distance(d0, 10.+m1*4.))*step(0.7,distance(z1,(uc)));
			   float3 co = pow(tex2D(_grad, float2(_Time.x*80.+0.5, 0.)).xyz,0.2);
                return float4(col.x*co+l1+frac(uc),1.);
            }
            ENDCG
        }
    }
}
