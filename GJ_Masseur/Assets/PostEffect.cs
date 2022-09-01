using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class PostEffect : MonoBehaviour
{

    public Material effect;
    [Range(0, 1)]
    public float flash;
    [Range(0, 1)]
    public float mvt;
    void Update()
    {

    }
        void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, effect);
        effect.SetFloat("_flash", flash);
        effect.SetFloat("_mvt", mvt);
    }
}