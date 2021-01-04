using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Windows;
using UnityEditor;
using System.IO;

namespace Utility
{
    public class Es_TerrainAlbemMaker
    {
        static int adgeAdd;
        static public Texture2D splatID;
        static public void MakeAlbedoAtlas(Material myMaterial, string name)
        {
            Texture2D[] TextureList = new Texture2D[16];
            int sqrCount = 4;
            char id = '0';
            Color[] Colors = new Color[256*256];
            int len = Colors.Length;
            for(int i = 0; i < len; ++i)
                Colors[i] = new Color(0, 0, 0, 0);
            for(int i = 0; i < 16; ++i)
            {
                if (myMaterial.HasProperty("_Splat" + id))
                {
                    Debug.Log("_Splat" + id);
                    TextureList[i] = (Texture2D)myMaterial.GetTexture("_Splat" + id);
                }
                else
                {
                    Debug.Log(i);
		            TextureList[i] = new Texture2D (256, 256,  TextureFormat.ARGB32, true);
                    TextureList[i].SetPixels(Colors);
                }
                ++id;
            }
            int wid = TextureList[0].width;
            int hei =TextureList[0].height;
            adgeAdd = 1;

            Texture2D albedoAtlas = new Texture2D(sqrCount * wid +  adgeAdd*sqrCount*2, sqrCount * hei + adgeAdd * sqrCount * 2, TextureFormat.RGBA32, true);
            Texture2D normalAtlas = new Texture2D(sqrCount * wid + adgeAdd * sqrCount * 2, sqrCount * hei + adgeAdd * sqrCount * 2, TextureFormat.RGBA32, true);
            Debug.Log(albedoAtlas.width);
            for (int i = 0; i < sqrCount; i++)
            {
                for (int j = 0; j < sqrCount; j++)
                {
                    int index = i * sqrCount + j;

                    if (index >= TextureList.Length) break;
                    copyToAltas(TextureList[index], albedoAtlas, i, j, wid, hei);
                    //copyToAltas(normalTerrainData.splatPrototypes[index].normalMap, normalAtlas, i, j, wid, hei);
                }
            }

            albedoAtlas.Apply();
            normalAtlas.Apply();
            
            string savePath = Application.dataPath+"/"+"Es_TerrainAtlas"+"/"+name;
            DirectoryInfo mydir = new DirectoryInfo(savePath);
            if(!mydir.Exists)
                System.IO.Directory.CreateDirectory(savePath);
            System.IO.File.WriteAllBytes(savePath+"/albedoAtlas.png",albedoAtlas.EncodeToPNG());
            System.IO.File.WriteAllBytes(savePath+"/normalAtlas.png",normalAtlas.EncodeToPNG());
            Object.DestroyImmediate(albedoAtlas);
            Object.DestroyImmediate(normalAtlas);
            AssetDatabase.Refresh();
        }
        static private void copyToAltas(Texture2D src, Texture2D texture, int i, int j, int wid, int hei)
        {
        
            if (src == null) return;
            //原始像素
            texture.SetPixels(j * (wid + 2 * adgeAdd) + adgeAdd, i * (hei + 2 * adgeAdd) + adgeAdd, wid, hei, src.GetPixels());
        
            //加4条边

            var lineColors = src.GetPixels(wid - 1, 0, 1, hei);
            var fillColor = new Color[hei * adgeAdd];
            for (int k = 0; k < hei * adgeAdd; k++)
            {
                fillColor[k] = lineColors[k % hei];
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd), i * (hei + 2 * adgeAdd) + adgeAdd, adgeAdd, hei, fillColor);

            lineColors = src.GetPixels(0, 0, 1, hei);
            for (int k = 0; k < hei * adgeAdd; k++)
            {
                fillColor[k] = lineColors[k % hei];
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd) + wid + adgeAdd, i * (hei + 2 * adgeAdd) + adgeAdd, adgeAdd, hei, fillColor);

            fillColor = new Color[wid * adgeAdd];
            lineColors = src.GetPixels(0, hei - 1, wid, 1);
            for (int k = 0; k < wid * adgeAdd; k++)
            {
                fillColor[k] = lineColors[k % wid];
            }

            texture.SetPixels(j * (wid + 2 * adgeAdd) + adgeAdd, i * (hei + 2 * adgeAdd), wid, adgeAdd, fillColor);
            lineColors = src.GetPixels(0, 0, wid, 1);
            for (int k = 0; k < wid * adgeAdd; k++)
            {
                fillColor[k] = lineColors[k % wid];
            }

            texture.SetPixels(j * (wid + 2 * adgeAdd) + adgeAdd, i * (hei + 2 * adgeAdd) + hei + adgeAdd, wid, adgeAdd, fillColor);


            //加4个角
            var cornerColor = src.GetPixel(0, hei - 1);
            fillColor = new Color[adgeAdd * adgeAdd];
            for (int k = 0; k < fillColor.Length; k++)
            {
                fillColor[k] = cornerColor;
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd), i * (hei + 2 * adgeAdd), adgeAdd, adgeAdd, fillColor);
            cornerColor = src.GetPixel(0, 0);

            for (int k = 0; k < fillColor.Length; k++)
            {
                fillColor[k] = cornerColor;
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd), i * (hei + 2 * adgeAdd) + hei + adgeAdd, adgeAdd, adgeAdd, fillColor);

            cornerColor = src.GetPixel(wid - 1, hei - 1);

            for (int k = 0; k < fillColor.Length; k++)
            {
                fillColor[k] = cornerColor;
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd) + adgeAdd + wid, i * (hei + 2 * adgeAdd), adgeAdd, adgeAdd, fillColor);


            cornerColor = src.GetPixel(wid - 1, 0);

            for (int k = 0; k < fillColor.Length; k++)
            {
                fillColor[k] = cornerColor;
            }
            texture.SetPixels(j * (wid + 2 * adgeAdd) + adgeAdd + wid, i * (hei + 2 * adgeAdd) + hei + adgeAdd, adgeAdd, adgeAdd, fillColor);

        }
        
        struct SplatData
        {
            public int id;
            public float weight;
            public float nearWeight;
        }

        static public void MakeSplat(Material myMaterial,string name)
        {
            // if(!myMaterial.HasProperty("_Control2"))
            //     return;
            List<Color[]> colors = new List<Color[]>();
            char indx = '\0';
            Texture2D[] MySplat = new Texture2D[4];

            Color[] DefualtColors = new Color[512*512];
            int len = DefualtColors.Length;
            for(int i = 0; i < len; ++i)
                DefualtColors[i] = new Color(0, 0, 0, 0);

            int wid = ((Texture2D)myMaterial.GetTexture("_Control" + indx)).width;
            int hei = ((Texture2D)myMaterial.GetTexture("_Control" + indx)).height;

            for(int i = 0; i < 4; ++i)
            {
                string tmp = "_Control" + indx;
                if(i == 0)
                    tmp = "_Control";
                if(myMaterial.HasProperty(tmp))
                {
                    colors.Add(((Texture2D)myMaterial.GetTexture(tmp)).GetPixels());
                    MySplat[i] = new Texture2D (512, 512,  TextureFormat.ARGB32, true);
                    MySplat[i] = (Texture2D)myMaterial.GetTexture(tmp);
                    // File.WriteAllBytes(Application.dataPath+"/"+ tmp +".png",MySplat[i].EncodeToPNG());
                }
                else
                {
                    //colors.Add(DefualtColors);
                    MySplat[i] = new Texture2D (512, 512,  TextureFormat.ARGB32, true);
                    MySplat[i].SetPixels(DefualtColors);
                }
                if(i == 0)
                    indx = '1';
                ++indx;
            }
            // t.terrainData.alphamapTextures[i].GetPixels();
            // for (int i = 0; i < normalTerrainData.alphamapTextures.Length; i++)
            // {
            //     colors.Add(normalTerrainData.alphamapTextures[i].GetPixels());
            // }

            splatID = new Texture2D(wid, hei, TextureFormat.RGB24, false, true);

            splatID.filterMode = FilterMode.Point;

            var splatIDColors = splatID.GetPixels();    
            for (int i = 0; i < hei; i++)
            {
                for (int j = 0; j < wid; j++)
                {
                    List<SplatData> splatDatas = new List<SplatData>();
                    int index = i * wid + j;
                    // splatIDColors[index].r=1 / 16.0f;
                    //struct 是值引用 所以 Add到list后  可以复用（修改他属性不会影响已经加入的数据）
                    for (int k = 0; k < colors.Count; k++)
                    {
                        SplatData sd;
                        sd.id = k * 4;
                        sd.weight = colors[k][index].r;
                        sd.nearWeight = getNearWeight(colors[k], index, wid, 0);
                        splatDatas.Add(sd);
                        sd.id++;
                        sd.weight = colors[k][index].g;
                        sd.nearWeight = getNearWeight(colors[k], index, wid, 1);

                        splatDatas.Add(sd);
                        sd.id++;
                        sd.weight = colors[k][index].b;
                        sd.nearWeight = getNearWeight(colors[k], index, wid, 2);

                        splatDatas.Add(sd);
                        sd.id++;
                        sd.weight = colors[k][index].a;
                        sd.nearWeight = getNearWeight(colors[k], index, wid, 3);

                        splatDatas.Add(sd);
                    }
                    //按权重排序选出最重要几个
                    splatDatas.Sort((x, y) => -(x.weight+x.nearWeight).CompareTo(y.weight+y.nearWeight));
                    //只存最重要3个图层 用一点压缩方案可以一张图存更多图层 ,这里最多支持16张
                    splatIDColors[index].r = splatDatas[0].id / 16f; //
                    splatIDColors[index].g = splatDatas[1].id / 16f;
                    splatIDColors[index].b =  splatDatas[2].id / 16f;
                }
            }
            
            splatID.SetPixels(splatIDColors);
            splatID.Apply();
            // 改用图片文件时可设置压缩为R8 代码生成有格式限制 空间有点浪费
            Texture2D splatWeight = new Texture2D(wid*2, hei*2, TextureFormat.ARGB32, true, true);
            splatWeight.filterMode = FilterMode.Bilinear;
            for (int i = 0; i < 4; i++)
            {
                splatWeight.SetPixels((i%2)*wid,(i/2)*hei,wid,hei,MySplat[i].GetPixels());
            }
            splatWeight.Apply();
            string savePath = Application.dataPath+"/"+"Es_TerrainAtlas"+"/"+name;
            DirectoryInfo mydir = new DirectoryInfo(savePath);
            if(!mydir.Exists)
                System.IO.Directory.CreateDirectory(savePath);
            System.IO.File.WriteAllBytes(savePath+"/splatWeight.png",splatWeight.EncodeToPNG());
            System.IO.File.WriteAllBytes(savePath+"/splatID.png",splatID.EncodeToPNG());
            AssetDatabase.Refresh();
        }

        static private float getNearWeight(Color[] colors, int index, int wid, int rgba)
        {
            float value = 0;
            for (int i = 1; i <= 2; i++)
            {
                value += colors[(index + colors.Length - i) % colors.Length][rgba];
                value += colors[(index + colors.Length + i) % colors.Length][rgba];
                value += colors[(index + colors.Length - wid * i) % colors.Length][rgba];
                value += colors[(index + colors.Length + wid * i) % colors.Length][rgba];
                value += colors[(index + colors.Length + (-1 - wid) * i) % colors.Length][rgba];
                value += colors[(index + colors.Length + (-1 + wid) * i) % colors.Length][rgba];
                value += colors[(index + colors.Length + (1 - wid) * i) % colors.Length][rgba];
                value += colors[(index + colors.Length + (1 + wid) * i) % colors.Length][rgba];
            }

            return value / (8 * 2);
        }
    }
}
