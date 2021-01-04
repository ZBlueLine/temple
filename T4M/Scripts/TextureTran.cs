using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class TextureTran : MonoBehaviour
{
    // Start is called before the first frame update
    public Texture albedoAtlas;
    public Texture splatID;
    public Texture splatWeight;

    [ContextMenu("Renderer")]
    void Renderer()
    {
        Shader.SetGlobalTexture("SpaltIDTex", splatID);
        Shader.SetGlobalTexture("SpaltWeightTex", splatWeight);
        Shader.SetGlobalTexture("AlbedoAtlas", albedoAtlas);
        //Shader.SetGlobalTexture("NormalAtlas", normalAtlas);
    }
}
