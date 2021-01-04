Shader "Es_Terrain/Blender"
{
    Properties{
        _BlockMainTex("Block MainTexture", 2D) = "white" {}
        _WeightTex("Weight Texture", 2D) = "white" {}
        _IDTex("ID Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        _BlockScale("Block Scale", float) = 1.0
    }

    SubShader{
        Pass{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"
            #include "TerrainSplatmapCommonFast.cginc"

            sampler2D _BlockMainTex;
            sampler2D _WeightTex;
            sampler2D _IDTex;
            float4 _IDTex_ST;
            float4 _WeightTex_ST;
            
            fixed4 _Color;
            float _BlockScale;

            struct a2v{
                float4 texcoord : TEXCOORD0;
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f{
                float4 pos : SV_POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 worldpos : TEXCOORD1;
                float2 uvw : TEXCOORD2;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldpos = mul(unity_ObjectToWorld, v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.texcoord.xy * _IDTex_ST.xy + _IDTex_ST.zw;
                o.uvw = v.texcoord.xy * _WeightTex_ST.xy + _WeightTex_ST.zw;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 worldSpaceLightDir = normalize(UnityWorldSpaceLightDir(i.pos));

                fixed4 IdCoord = tex2D(_IDTex, i.uv);
                
                int id1 = IdCoord.r * 16;
                int id2 = IdCoord.g * 16;
                int id3 = IdCoord.b * 16;

                i.uvw *= 0.5f;
                int idx = id2 / 4 % 2;
                int idy = id2 / 4 / 2;

                float4 Weight = tex2D(_WeightTex, i.uvw + float2(idx*0.5, idy*0.5));
                float Weight2 = getChannelValue(Weight, IdCoord.g * 16 % 4);

                idx = id3 / 4 % 2;
                idy = id3 / 4 / 2;

                Weight = tex2D(_WeightTex, i.uvw + float2(idx*0.5, idy*0.5));
                float Weight3 = getChannelValue(Weight, IdCoord.b * 16 % 4);

                float Weight1 = 1 - Weight2 - Weight3;
                
                return fixed4(Weight1, Weight2, Weight3, 1.0);
                
                //return fixed4(SamplerCoord.xyz, 1.0);
                //float blendRatio = tex2D(_IDTex, i.uv).z;

                // float2 twoVerticalIndices;
                // float2 twoHorizontalIndices;
                // twoVerticalIndices = floor(SamplerCoord.rg * 16.0);
                // twoHorizontalIndices = (floor(SamplerCoord.rg * 256.0)) - (twoVerticalIndices.xy * 16);
                // //return fixed4(twoVerticalIndices.y, 0, 0, 1.0);
                // float4 decodeIndices;
                // decodeIndices.x = twoVerticalIndices.x;
                // decodeIndices.y = twoHorizontalIndices.x;
                // decodeIndices.z = twoVerticalIndices.y;
                // decodeIndices.w = twoHorizontalIndices.y;
                // decodeIndices = floor(decodeIndices/4)/4;
                
                // float2 worldScale = i.worldpos.xz * _BlockScale;
                // float2 worldUv = 0.234375 * frac(worldScale) + 0.0078125;

                // float2 dx = clamp(0.234375 * ddx(worldScale), -0.0078125, 0.0078125);
                // float2 dy = clamp(0.234375 * ddy(worldScale), -0.0078125, 0.0078125);

                // float2 uv0 = worldUv + decodeIndices.yx;
                // float2 uv1 = worldUv + decodeIndices.wz;
                
                // float4 col0 = tex2D(_BlockMainTex, uv0, dx, dy);
                // float4 col1 = tex2D(_BlockMainTex, uv1, dx, dy);

                // float4 diffuseColor = lerp(col0, col1, blendRatio);
                

                // fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;
                // fixed3 diffuse = _LightColor0.rgb * diffuseColor.rgb * max(0, dot(i.normal, worldSpaceLightDir));
                // return fixed4(diffuse, 1.0);
            }
            ENDCG
        }
    }
}
