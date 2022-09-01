Shader "Unlit/stickman"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_bnoise("bnoise", 2D) = "white" {}
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
            fixed4 frag (v2f i) : SV_Target
            {


			float2 uv = (i.uv - 0.5)*2.;
			float t = floor(_Time.y*20.)*0.05;
			uv = mul(uv, rot(sin(t*4.)*0.1));
			uv.x += sin(uv.y*3. + t*4.)*0.025;
			float tti = t*3.;
			uv.y += pow(lerp(frac(tti),1.-frac(tti),step(0.5,frac(tti*0.5))),2.)*0.5+0.1;
			float ti = (sin(t)*0.5 + 0.5)*5. + t * 10.;
			float l1 = smoothstep(0.45, 0., li(uv, float2(0., -0.2), float2(0., 0.2)));
			float tt = sin(ti);
			float2 ub = uv + float2(0., -pow(length(uv.x), 2.)*(tt))*0.7;
			float2 ug = uv + float2(-pow(length(uv.y), 2.)*(tt), 0.)*0.2*-sign(uv.x)*length(uv);
			float bb = smoothstep(0.3, 0., li(ub, float2(0., 0.25), float2(0.5, tt*0.2 + 0.2)));
			l1 = max(bb, l1);
			float ba = smoothstep(0.3, 0., li(ub, float2(0., 0.25), float2(-0.5, tt*0.2 + 0.2)));
			l1 = max(ba, l1);
			l1 = max(smoothstep(0.3, 0., li(ug, float2(0.05, -0.2), float2(0.25 + sin(ti + 3.14)*0.15, -0.8))), l1);
			l1 = max(smoothstep(0.3, 0., li(ug, float2(-0.05, -0.22), float2(-0.25 + tt * 0.15, -0.8))), l1);
			float2 zb = uv - float2(0., 0.45 + tt * 0.05);
			float bc = smoothstep(0.45 + tt * -0.02, 0., length(zb));
			l1 = max(l1, bc);
			float l2 = lerp(lerp(uv.y, uv.x, step(0.7, max(ba, bb))), abs(atan2(zb.x, zb.y))*-0.1, step(0.7, bc));
			float l3 = step(0.5, frac(l2*5. + floor(_Time.y*30.)/10. * sign(uv.x)));
			float uc =(atan2(uv.x, uv.y));
			float2 b1 = (tex2D(_MainTex, float2(uc*0.3,_Time.y)).xy-0.5)*length(uv)*0.8;
			float r1 = smoothstep(0.03,0.,distance(0.77+b1.x, l1))*lerp(0.7,1.,l3)+ smoothstep(0.03, 0., distance(0.77 + b1.y, l1))*l3;
			//r1 += +(smoothstep(0.05, 0., distance(l1, 0.25 + b1.y*0.2)) + smoothstep(0.05, 0., distance(l1, 0.1 + b1.x*0.2)))*step( distance(float2(abs(ub.x), ub.y), float2(0.7, tt*0.2 + 0.2)),0.2)*step(0.8, rd(_Time.x));
			//r1 *= l3;
			//r1 *= step(0.5, frac(uc*.));
			float2 un = i.screenPosition * float2(1.78, 1.);
			float bt = rd(_Time.x);
			un = mul(un, rot(bt*6.));
			un += float2(rd(_Time.x + 47.42), rd(_Time.x + 457.23));
			float tr = smoothstep(0.1, 0.85, lerp(tex2D(_stroke, un).x, lerp(tex2D(_stroke, un).z, tex2D(_stroke, un).y, step(0.5, rd(_Time.x + 475.23))), step(0.5, rd(_Time.x + 956.))));

			r1 =ov(r1*0.7, pow(tex2D(_bnoise, i.screenPosition*2. - _Time.x*10.).x, tr*10.));

			float3 col = pow(tex2D(_grad, float2(_Time.x*80., 0.)).xyz,0.25);

                return float4(col*r1,1.);
            }
            ENDCG
        }
    }
}
