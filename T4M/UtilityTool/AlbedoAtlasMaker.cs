/*using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AlbedoMaker
{
    void MakeAlbedoAtlas()
    {
        int sqrCount = 4;
        int wid = normalTerrainData.splatPrototypes[0].texture.width;
        int hei = normalTerrainData.splatPrototypes[0].texture.height;
        adgeAdd = 1;

        albedoAtlas = new Texture2D(sqrCount * wid + adgeAdd * sqrCount * 2, sqrCount * hei + adgeAdd * sqrCount * 2, TextureFormat.RGBA32, true);
        normalAtlas = new Texture2D(sqrCount * wid + adgeAdd * sqrCount * 2, sqrCount * hei + adgeAdd * sqrCount * 2, TextureFormat.RGBA32, true);
        print(albedoAtlas.width);
        for (int i = 0; i < sqrCount; i++)
        {
            for (int j = 0; j < sqrCount; j++)
            {
                int index = i * sqrCount + j;

                if (index >= normalTerrainData.splatPrototypes.Length) break;
                copyToAltas(normalTerrainData.splatPrototypes[index].texture, albedoAtlas, i, j, wid, hei);
                copyToAltas(normalTerrainData.splatPrototypes[index].normalMap, normalAtlas, i, j, wid, hei);
            }
        }

        albedoAtlas.Apply();
        normalAtlas.Apply();
        File.WriteAllBytes(Application.dataPath + "/albedoAtlas.png", albedoAtlas.EncodeToPNG());
        File.WriteAllBytes(Application.dataPath + "/normalAtlas.png", normalAtlas.EncodeToPNG());
        DestroyImmediate(albedoAtlas);
        DestroyImmediate(normalAtlas);
    }
}
*/