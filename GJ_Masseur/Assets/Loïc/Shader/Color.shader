// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Color"
{
	Properties
	{
		_ColorScrollSpeed("ColorScrollSpeed", Range( 1 , 7)) = 0.4
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_WhiteToColor("White To Color", Range( 0 , 1)) = 0
		[Toggle(_0RED1GREEN_ON)] _0Red1Green("0Red/1Green", Float) = 0
		[Toggle(_0BLUE1ALPHA_ON)] _0Blue1Alpha("0Blue/1Alpha", Float) = 0
		[Toggle(_0RG1BA_ON)] _0RG1BA("0RG/1BA", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _0RG1BA_ON
		#pragma shader_feature_local _0RED1GREEN_ON
		#pragma shader_feature_local _0BLUE1ALPHA_ON
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _ColorScrollSpeed;
		uniform float _WhiteToColor;
		uniform sampler2D _TextureSample0;
		SamplerState sampler_TextureSample0;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float lerpResult94 = lerp( 0.0 , 1.0 , _WhiteToColor);
			float3 hsvTorgb54 = HSVToRGB( float3((0.0 + (( _SinTime.x * _ColorScrollSpeed ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)),lerpResult94,1.0) );
			float3 hsvTorgb59 = HSVToRGB( float3(( (0.0 + (( ( _SinTime.w / 16.0 ) * _ColorScrollSpeed ) - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) + 1.0 ),lerpResult94,1.0) );
			float temp_output_84_0 = (-0.5 + (( ( _SinTime.w / 10.0 ) * 1.0 ) - -0.5) * (0.5 - -0.5) / (0.5 - -0.5));
			float lerpResult80 = lerp( i.uv_texcoord.y , 0.0 , ( temp_output_84_0 + 0.0 ));
			float3 lerpResult61 = lerp( hsvTorgb54 , hsvTorgb59 , ( lerpResult80 * length( (i.uv_texcoord*0.5 + temp_output_84_0) ) ));
			o.Emission = ( lerpResult61 * 1.0 );
			float4 tex2DNode82 = tex2D( _TextureSample0, i.uv_texcoord );
			#ifdef _0RED1GREEN_ON
				float staticSwitch99 = tex2DNode82.g;
			#else
				float staticSwitch99 = tex2DNode82.r;
			#endif
			#ifdef _0BLUE1ALPHA_ON
				float staticSwitch100 = tex2DNode82.a;
			#else
				float staticSwitch100 = tex2DNode82.b;
			#endif
			#ifdef _0RG1BA_ON
				float staticSwitch101 = staticSwitch100;
			#else
				float staticSwitch101 = staticSwitch99;
			#endif
			float smoothstepResult90 = smoothstep( 0.0 , 1.0 , staticSwitch101);
			o.Alpha = smoothstepResult90;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2682.857;475;1316;840;622.8417;114.4318;2.293858;True;False
Node;AmplifyShaderEditor.SinTimeNode;67;90.32402,592.5042;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;83;437.5745,1068.607;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;7.093414,813.5577;Inherit;False;Property;_ColorScrollSpeed;ColorScrollSpeed;0;0;Create;True;0;0;False;0;False;0.4;7;1;7;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;620.1481,1085.22;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;72;330.131,665.3552;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;16;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;776.7263,875.333;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;84;788.5009,1098.798;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-0.5;False;2;FLOAT;0.5;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;510.3449,653.5323;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;65;90.06918,408.5945;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;85;1017.645,1193.648;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;77;1206.987,939.5161;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0.5;False;2;FLOAT;-0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;96;562.6484,306.9956;Inherit;False;Property;_WhiteToColor;White To Color;2;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;716.5047,1.494709;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;68;670.124,647.1042;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;76;1521.971,1059.865;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;80;1845.168,810.545;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;64;889.9532,0.7200818;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;82;2137.837,506.021;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;False;-1;None;73f9ca0b58c565f4ba2b70b09296b9cb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;94;871.2366,264.0247;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;878.124,646.1042;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;54;1223.193,231.1577;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;2192.713,783.4073;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;99;2683.809,530.4637;Inherit;False;Property;_0Red1Green;0Red/1Green;3;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;100;2686.242,627.7766;Inherit;False;Property;_0Blue1Alpha;0Blue/1Alpha;4;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;59;1225.37,500.0098;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;89;2353.59,390.9257;Inherit;False;Constant;_Float3;Float 3;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;61;2209.623,234.354;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;101;2975.748,602.232;Inherit;False;Property;_0RG1BA;0RG/1BA;5;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;90;3403.337,567.3864;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;2556.479,291.7617;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3636.851,344.6673;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Color;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;83;0;67;4
WireConnection;86;0;83;0
WireConnection;72;0;67;4
WireConnection;84;0;86;0
WireConnection;71;0;72;0
WireConnection;71;1;60;0
WireConnection;85;0;84;0
WireConnection;77;0;62;0
WireConnection;77;2;84;0
WireConnection;70;0;65;1
WireConnection;70;1;60;0
WireConnection;68;0;71;0
WireConnection;76;0;77;0
WireConnection;80;0;62;2
WireConnection;80;2;85;0
WireConnection;64;0;70;0
WireConnection;82;1;62;0
WireConnection;94;2;96;0
WireConnection;69;0;68;0
WireConnection;54;0;64;0
WireConnection;54;1;94;0
WireConnection;92;0;80;0
WireConnection;92;1;76;0
WireConnection;99;1;82;1
WireConnection;99;0;82;2
WireConnection;100;1;82;3
WireConnection;100;0;82;4
WireConnection;59;0;69;0
WireConnection;59;1;94;0
WireConnection;61;0;54;0
WireConnection;61;1;59;0
WireConnection;61;2;92;0
WireConnection;101;1;99;0
WireConnection;101;0;100;0
WireConnection;90;0;101;0
WireConnection;88;0;61;0
WireConnection;88;1;89;0
WireConnection;0;2;88;0
WireConnection;0;9;90;0
ASEEND*/
//CHKSM=773FD3F49BE7D60BF4F292E65BE08615F05A5FFF