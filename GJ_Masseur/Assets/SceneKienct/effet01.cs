using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(GrayscaleRenderer), PostProcessEvent.AfterStack, "Custom/effet01")]
public sealed class effet01 : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("effet01 effect intensity.")]
    public FloatParameter effet = new FloatParameter { value = 0.5f };
    public FloatParameter distance = new FloatParameter { value = 0.5f };
    public TextureParameter noise = new TextureParameter { value = null, defaultState = TextureParameterDefault.Black };
}

public sealed class GrayscaleRenderer : PostProcessEffectRenderer<effet01>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/effet01"));
        sheet.properties.SetFloat("_effet", settings.effet);
        sheet.properties.SetFloat("_distance", settings.distance);
        sheet.properties.SetTexture("_noise", settings.noise);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}