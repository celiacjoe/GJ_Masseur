Shader "Unlit/lignespart"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
	    _noise("noise", 2D) = "white" {}
		_bnoise("bnoise", 2D) = "white" {}
		_stroke("stroke", 2D) = "white" {}
		_grad("grad", 2D) = "white" {}

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
				float4 screenPosition : TEXCOORD1;
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
            float li(float2 uv, float2 a, float2 b) {
                float2 ua = uv - a; float2 ba = b - a;
                float h = clamp(dot(ua, ba) / dot(ba, ba), 0., 1.);
                return length(ua - ba * h);
            }
            float rn(float t) { return frac(sin(dot(floor(t), 45.)) * 4512.235); }
            float no(float t) { return lerp(rn(t), rn(t + 1.), smoothstep(0., 1., frac(t))); }
			float ov(float base, float blend) {
				return base < 0.5 ? (2.0*base*blend) : (1.0 - 2.0*(1.0 - base)*(1.0 - blend));
			}
			float hs(float2 uv, float t) { return frac(sin(dot(uv, float2(45.95, 78.14)))*7845.236 + t); }
			float rd(float uv) { return frac(sin(dot(floor(uv*80.), 45.236))*7845.236); }
			float2x2 rot(float t) { float c = cos(t); float s = sin(t); return float2x2(c, -s, s, c); }
            fixed4 frag(v2f i) : SV_Target
            {
                //float3 col = clamp( 3.*abs(1.-2.*frac(_Time.x*40.+float3(0.,-1./3.,1./3.)))-1.,0.,1.);
				float3 col = tex2D(_grad,float2(_Time.x*80.,0.)).xyz;
                float t = tex2D(_MainTex, float2(0.,i.uv.x*0.3+_Time.x*10.)).x-0.5;
                float t2 = tex2D(_MainTex, float2(0.3, i.uv.x * 0.3 - _Time.x * 10.)).x-0.5;
                float t3 = tex2D(_MainTex, float2(0.6,  _Time.x * 10.)).x-0.5;

				//float no = pow(tex2D(_noise, i.screenPosition-_Time.x*10.).x,2.5)*0.0;
                float m = smoothstep(0.1,0. ,li(i.uv+float2(0.,t)+t3*0.2, float2(0.1, 0.5), float2(0.95, 0.5)));
                m += smoothstep(0.1 , 0. , li(i.uv  + float2( 0.,t2)-t3*0.2, float2(0.1, 0.5) , float2(0.95, 0.5) ));
				float2 un = i.screenPosition * float2(1.78, 1.);
				float bt = rd(_Time.x);
				un = mul(un, rot(bt*6.));
				un += float2(rd(_Time.x + 47.42), rd(_Time.x + 457.23));
				float tr = smoothstep(0.1,0.85,lerp(tex2D(_stroke, un).x, lerp(tex2D(_stroke, un).z, tex2D(_stroke, un).y, step(0.5, rd(_Time.x + 475.23))), step(0.5, rd(_Time.x + 956.))));

				m =  ov(m*0.7,  pow(tex2D(_bnoise, i.screenPosition*2. - _Time.x*10.).x,tr*20.));
                return float4(col,m);
            }
            ENDCG
        }
    }
}
