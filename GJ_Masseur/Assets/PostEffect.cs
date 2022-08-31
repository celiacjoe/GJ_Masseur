using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class PostEffect : MonoBehaviour
{

    public Material effect;
    [Range(0, 1)]
    public float flash;
    void Update()
    {

    }
        void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, effect);
        effect.SetFloat("_flash", flash);
    }
}