// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Base"
{
	Properties
	{
		_Length("Length", Float) = 1
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Multyply("Multyply", Float) = 2
		_Min("Min", Float) = -2
		_Noisescale("Noise scale", Float) = 1
		_Max("Max", Float) = 1
		_Offset("Offset", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Length;
		uniform float _Offset;
		uniform float _Noisescale;
		uniform float _Multyply;
		uniform float _Min;
		uniform float _Max;
		uniform float _EdgeLength;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float customSurfaceDepth15 = -UnityObjectToViewPos( ase_vertex3Pos ).z;
			float cameraDepthFade15 = (( customSurfaceDepth15 -_ProjectionParams.y - _Offset ) / _Length);
			float temp_output_65_0 = ( _Noisescale / 10.0 );
			float lerpResult64 = lerp( ( _Noisescale + temp_output_65_0 ) , ( _Noisescale - temp_output_65_0 ) , (0.0 + (_SinTime.z - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)));
			float simplePerlin3D54 = snoise( ase_vertex3Pos*lerpResult64 );
			simplePerlin3D54 = simplePerlin3D54*0.5 + 0.5;
			float clampResult28 = clamp( (_Min + (sin( ( ( cameraDepthFade15 + simplePerlin3D54 ) * _Multyply * 6.28318548202515 ) ) - -1.0) * (_Max - _Min) / (1.0 - -1.0)) , 0.0 , 1.0 );
			float3 temp_cast_0 = (clampResult28).xxx;
			o.Emission = temp_cast_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2600.857;530;1412;840;2338.542;142.3689;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;56;-1850.494,-39.8405;Inherit;False;Property;_Noisescale;Noise scale;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;62;-1922.893,139.066;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;65;-1617.893,77.06601;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;68;-1501.893,232.066;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;67;-1434.893,33.06601;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-1450.893,-60.93399;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;64;-1273.893,-30.93399;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;57;-1700.743,-170.5711;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-1960.786,315.7778;Inherit;False;Property;_Length;Length;0;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1753.69,407.3851;Inherit;True;Property;_Offset;Offset;10;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;54;-931.0129,-89.64236;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;3.29;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;15;-1166.175,273.6365;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1051.556,361.9287;Inherit;False;Property;_Multyply;Multyply;6;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;26;-1034.085,498.4511;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-596.4883,61.04701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-471.6295,254.7905;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;3;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-587.9933,661.6522;Inherit;False;Property;_Min;Min;7;0;Create;True;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;25;-240.5523,257.9842;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-585.9933,740.6522;Inherit;False;Property;_Max;Max;9;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;30;372.4138,205.894;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-2;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;28;662.4902,201.988;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;813.7182,159.1511;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Base;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;65;0;56;0
WireConnection;68;0;62;3
WireConnection;67;0;56;0
WireConnection;67;1;65;0
WireConnection;66;0;56;0
WireConnection;66;1;65;0
WireConnection;64;0;66;0
WireConnection;64;1;67;0
WireConnection;64;2;68;0
WireConnection;54;0;57;0
WireConnection;54;1;64;0
WireConnection;15;2;57;0
WireConnection;15;0;16;0
WireConnection;15;1;17;0
WireConnection;59;0;15;0
WireConnection;59;1;54;0
WireConnection;22;0;59;0
WireConnection;22;1;44;0
WireConnection;22;2;26;0
WireConnection;25;0;22;0
WireConnection;30;0;25;0
WireConnection;30;3;42;0
WireConnection;30;4;43;0
WireConnection;28;0;30;0
WireConnection;0;2;28;0
ASEEND*/
//CHKSM=183E3AB3709A20A8A0CE10EA86AA75A77B7AB3F3