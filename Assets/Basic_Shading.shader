Shader "Unlit/Basic_Shading"
{
	Properties
	{
		_MainColor ("Color", Color) = (0.5,0.5,0.5)
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
				fixed4 vertex : POSITION;
				fixed2 uv : TEXCOORD0;
				fixed4 color : COLOR;
				fixed3 normal : NORMAL;
			};

			struct v2f
			{
				fixed2 uv : TEXCOORD0;
				fixed4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				fixed3 normal : NORMAL;
			};

			fixed4 _MainColor;
			fixed3 _lightDir;
			
			v2f vert (appdata v)
			{
				v2f o;

				o.normal = UnityObjectToWorldNormal(v.normal);
				o.normal = normalize(o.normal);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = _MainColor;

				return o;
			}
			
			
			fixed4 frag (v2f i) : SV_Target
			{
				_lightDir = _WorldSpaceLightPos0.xyz;
				fixed l = saturate(dot(_lightDir, i.normal));
				fixed4 col = _MainColor * (l + unity_AmbientSky);
				return float4(_lightDir,0);
			}
			ENDCG
		}
	}
}
