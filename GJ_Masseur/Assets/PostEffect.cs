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
    [Range(0, 1)]
    public float fin;
    public AudioSource audioflash;
    void Update()
    {
     if(flash != 0) { audioflash.enabled=true; }
     else { audioflash.enabled=false; }
    }
        void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, effect);
        effect.SetFloat("_flash", flash);
        effect.SetFloat("_mvt", mvt);
        effect.SetFloat("_fin", fin);
    }
}