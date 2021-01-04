// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Es_Terrain/16 Bumped Diffuse" {
	Properties {
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		_Splat0("Layer1 (RGB)", 2D) = "white" {}
		_Splat1("Layer2 (RGB)", 2D) = "white" {}
		_Splat2("Layer2 (RGB)", 2D) = "white" {}
		_Splat3("Layer2 (RGB)", 2D) = "white" {}
		_Splat4("Layer2 (RGB)", 2D) = "white" {}
		_Splat5("Layer2 (RGB)", 2D) = "white" {}
		_Splat6("Layer2 (RGB)", 2D) = "white" {}
		_Splat7("Layer2 (RGB)", 2D) = "white" {}
		_Splat8("Layer1 (RGB)", 2D) = "white" {}
		_Splat9("Layer2 (RGB)", 2D) = "white" {}
		_Splat10("Layer2 (RGB)", 2D) = "white" {}
		_Splat11("Layer2 (RGB)", 2D) = "white" {}
		_Splat12("Layer2 (RGB)", 2D) = "white" {}
		_Splat13("Layer2 (RGB)", 2D) = "white" {}
		_Splat14("Layer2 (RGB)", 2D) = "white" {}
		_Splat15("Layer2 (RGB)", 2D) = "white" {}

		_Control("Splat (RGB)", 2D) = "white" {}
		_Control2("Splat2 (RGB)", 2D) = "white" {}
		_Control3("Splat (RGB)", 2D) = "white" {}
		_Control4("Splat2 (RGB)", 2D) = "white" {}

		//_BumpMap ("Normal Map", 2D) = "bump" {}
		//_MainTex("Never Used", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry"}

		Pass { 
			Tags { "LightMode"="ForwardBase" }
		
			CGPROGRAM
			
			#pragma multi_compile_fwdbase
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			sampler2D _Control;
			sampler2D _Control2;
			sampler2D _Control3;
			sampler2D _Control4;

			sampler2D _BumpMap;
			sampler2D _Splat0;
			sampler2D _Splat1;
			sampler2D _Splat2;
			sampler2D _Splat3;
			sampler2D _Splat4;
			sampler2D _Splat5;
			sampler2D _Splat6;
			sampler2D _Splat7;
			sampler2D _Splat8;


			float4 _MainTex_ST;
			float4 _BumpMap_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;
			float4 _Splat4_ST;
			float4 _Splat5_ST;
			float4 _Splat6_ST;
			float4 _Splat7_ST;
			float4 _Splat8_ST;
			float4 _Splat9_ST;
			float4 _Splat10_ST;
			float4 _Splat11_ST;
			float4 _Splat12_ST;
			float4 _Splat13_ST;
			float4 _Splat14_ST;
			float4 _Splat15_ST;

			fixed4 _Color;


			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 TtoW0 : TEXCOORD1;  
				float4 TtoW1 : TEXCOORD2;  
				float4 TtoW2 : TEXCOORD3;
			};
			
			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.texcoord.xy;

				o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
				
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;  
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);  
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);  
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w; 
				
				o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
				TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				fixed4 Cid1 = tex2D(_Control, i.uv.xy);
				fixed4 Cid2 = tex2D(_Control2, i.uv.xy);
				fixed4 Cid3 = tex2D(_Control3, i.uv.xy);
				fixed4 Cid4 = tex2D(_Control4, i.uv.xy);


				fixed3 Splat_color0 = tex2D(_Splat0, i.uv.xy * _Splat0_ST);
				fixed3 Splat_color1 = tex2D(_Splat1, i.uv.xy * _Splat1_ST);
				fixed3 Splat_color2 = tex2D(_Splat2, i.uv.xy * _Splat2_ST);
				fixed3 Splat_color3 = tex2D(_Splat3, i.uv.xy * _Splat3_ST);
				fixed3 Splat_color4 = tex2D(_Splat4, i.uv.xy * _Splat4_ST);
				fixed3 Splat_color5 = tex2D(_Splat5, i.uv.xy * _Splat5_ST);
				fixed3 Splat_color6 = tex2D(_Splat6, i.uv.xy * _Splat6_ST);
				fixed3 Splat_color7 = tex2D(_Splat7, i.uv.xy * _Splat7_ST);
				fixed3 Splat_color8 = tex2D(_Splat8, i.uv.xy * _Splat8_ST);


				fixed3 albedo = Cid1.r * Splat_color0.rgb;
				albedo += Cid1.r * Splat_color0.rgb;
				albedo += Cid1.g * Splat_color1.rgb;
				albedo += Cid1.b * Splat_color2.rgb;
				albedo += Cid1.a * Splat_color3.rgb;
				albedo += Cid2.r * Splat_color4.rgb;
				albedo += Cid2.g * Splat_color5.rgb;
				albedo += Cid2.b * Splat_color6.rgb;
				albedo += Cid2.a * Splat_color7.rgb;
				albedo += Cid3.r * Splat_color8.rgb;


				fixed3 bump = UnpackNormal(tex2D(_BumpMap, i.uv.zw));
				bump = normalize(half3(dot(i.TtoW0.xyz, bump), dot(i.TtoW1.xyz, bump), dot(i.TtoW2.xyz, bump)));
			
				//fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color.rgb;
				
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
			
			 	fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(bump, lightDir));
				
				UNITY_LIGHT_ATTENUATION(atten, i, worldPos);
				
				return fixed4(ambient + diffuse * atten, 1.0);
			}
			
			ENDCG
		}
		
		Pass { 
			Tags { "LightMode"="ForwardAdd" }
			
			Blend One One
		
			CGPROGRAM
			
			#pragma multi_compile_fwdadd
			// Use the line below to add shadows for point and spot lights
//			#pragma multi_compile_fwdadd_fullshadows
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			
			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 TtoW0 : TEXCOORD1;  
				float4 TtoW1 : TEXCOORD2;  
				float4 TtoW2 : TEXCOORD3;
				SHADOW_COORDS(4)
			};
			
			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
				
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;  
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);  
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);  
				fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w; 
				
				o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);  
				
				TRANSFER_SHADOW(o);
				
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {
				float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				
				fixed3 bump = UnpackNormal(tex2D(_BumpMap, i.uv.zw));
				bump = normalize(half3(dot(i.TtoW0.xyz, bump), dot(i.TtoW1.xyz, bump), dot(i.TtoW2.xyz, bump)));
				
				fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color.rgb;
				
			 	fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(bump, lightDir));
				
				UNITY_LIGHT_ATTENUATION(atten, i, worldPos);
				
				return fixed4(diffuse * atten, 1.0);
			}
			
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
