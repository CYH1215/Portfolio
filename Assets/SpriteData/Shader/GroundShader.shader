Shader "Custom/GroundShader" {
	Properties{
		_Maintex("Maintex", 2D) = "white" {}
		_BaseTex("BaseTex", 2D) = "white" {}

		[HideInInspector]_Cutoff("Alpha cutoff", Range(0,1)) = 0.5

		_Color("Tint", Color) = (1,1,1,1)


	}
		SubShader
		{
			LOD 200
			Tags
			{
				"IgnoreProjector" = "True"
				"Queue" = "Transparent"
				"RenderType" = "Transparent"
				"PreviewType" = "Plane"
				"CanUseSpriteAtlas" = "True"
			}

			Pass
			{
				Tags{
				"LightMode" = "ForwardBase"}
				Blend SrcAlpha OneMinusSrcAlpha
				ZWrite Off

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				#pragma target 3.0
				uniform sampler2D _BaseTex; uniform float4 _BaseTex_ST;
				uniform sampler2D _Maintex; uniform float4 _Maintex_ST;
				fixed4 _Color;



				struct VertexInput {
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					fixed2 uv : TEXCOORD0;

				};
				struct VertexOutput {

					fixed4 color : COLOR;
					fixed2 texcoord : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				VertexOutput vert(VertexInput v) {
					VertexOutput o = (VertexOutput)0;
					o.color = v.color * _Color;

					o.texcoord = v.uv;
					o.vertex = UnityObjectToClipPos(v.vertex);

					return o;
				}


				float4 frag(VertexOutput i) : COLOR{
					////// Lighting:
					float4 _BaseTex_var = tex2D(_BaseTex,TRANSFORM_TEX(i.texcoord, _BaseTex));
					float3 finalColor = _BaseTex_var.rgb;
					float4 _Maintex_var = tex2D(_Maintex,TRANSFORM_TEX(i.texcoord, _Maintex));

					_Maintex_var.rgb *= _Maintex_var.a;
					if (_Maintex_var.r != 1 && _Maintex_var.g != 1 && _Maintex_var.b != 1)
					{

							finalColor.r = _Maintex_var.r * _BaseTex_var.r;
							finalColor.g = _Maintex_var.g * _BaseTex_var.g;
							finalColor.b = _Maintex_var.b * _BaseTex_var.b;

					}



					return fixed4(finalColor, _Maintex_var.a) * _Color;



				}


				ENDCG
			}
		}
			FallBack "Diffuse"
}