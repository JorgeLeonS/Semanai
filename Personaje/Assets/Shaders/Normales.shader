/* Shader normal
Shader "Unlit/Normales"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			// make fog work
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
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				col.x *= 0.5; //Rojo = 1
				col.y *= 0.5; //Verde = 1
				//col.z = 0; //Azul = 0
				//col.w = 1; //Alpha (Transparencia) = 1

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
*/

//Shader profe

// https://docs.unity3d.com/Manual/SL-ShaderPrograms.html
// https://docs.unity3d.com/Manual/SL-VertexProgramInputs.html

Shader "Unlit/Normales"
{
	Properties
	{
		// we have removed support for texture tiling/offset,
		// so make them not be displayed in material inspector
		[NoScaleOffset] _MainTex("Texture", 2D) = "white" {}
		Scale("Scale", Range(-0.005, 1)) = 0.0
	}

		SubShader
		{
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				float Scale;

		// vertex input: position, normal, texture coordinate
		struct appdata {
			float4 vertex : POSITION;   // vertex position
			float3 normal : NORMAL;     // vertex normal
			float2 uv : TEXCOORD0;      // texture coordinate
		};

		// vertex output: position, texture coordinate OR color
		struct v2f
		{
			float4 pos : SV_POSITION;   // vertex position
			float2 uv : TEXCOORD0;      // texture coordinate
			fixed4 color : COLOR;       // color
			float3 normal : NORMAL;
		};

		v2f vert(appdata v)
		{
			v2f o;
			o.normal = UnityObjectToWorldNormal(v.normal);
			o.pos.xyz = v.vertex + v.normal * Scale;
			o.pos.w = 1.0;
			o.pos = UnityObjectToClipPos(o.pos);

			o.uv = v.uv;

			o.color.xyz = v.normal * 0.5 + 0.5;
			o.color.w = 1.0;
			return o;
		}

		sampler2D _MainTex;
		fixed4 frag(v2f i) : SV_Target
		{
			 //return either i.color or col
			fixed4 col = tex2D(_MainTex, i.uv);
		//return i.color;
		return col;
	}
	ENDCG
}
		}
}
