using System.Collections;
using System.Collections.Generic;

using UnityEngine;
using UnityEditor;

public class Es_Terrain_Renderer : MonoBehaviour
{
    // Start is called before the first frame update
    public Texture albedoAtlas;
    public Texture splatWeight;
    public Texture splatID;

    [ContextMenu("Renderer")]
    void Renderer()
    {
        Debug.Log(transform.name); 
        Material m_material = transform.GetComponent<Material>();
        //if(m_material)
        {
            // m_material.SetTexture("_BlockMainTex", albedoAtlas);
            // m_material.SetTexture("_WeightTex", splatWeight);
            // m_material.SetTexture("_IDTex", splatID);
            Shader.SetGlobalTexture("AlbedoAtlas", albedoAtlas);
            Shader.SetGlobalTexture("SpaltWeightTex", splatWeight);
            Shader.SetGlobalTexture("SpaltIDTex", splatID);
        }
        //Shader.SetGlobalTexture("NormalAtlas", normalAtlas);
    }
}
