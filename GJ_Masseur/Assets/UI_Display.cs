using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class UI_Display : MonoBehaviour
{
   // public Voice S_Voice;
    public Manager S_Manager;
    public TextMeshPro Counter;
    public TextMeshPro TextPhrase;
    public TextMeshPro TextSession;
    //private TMP_FontAsset m_FontAsset;
    public Animator AC;
    public bool PlayPhrase;

    public string Info01 = "Place";
    private const string label = "<#0050FF> </color>{0:2}";
    private float m_frame;


    void Start()
    {

        AC = gameObject.GetComponent<Animator>();
        PlayPhrase = false;

        // Add new TextMesh Pro Component
        //m_textMeshPro = gameObject.AddComponent<TextMeshPro>();

        //m_textMeshPro.autoSizeTextContainer = true;

        // Load the Font Asset to be used.
        //m_FontAsset = Resources.Load("Fonts & Materials/LiberationSans SDF", typeof(TMP_FontAsset)) as TMP_FontAsset;
        //m_textMeshPro.font = m_FontAsset;

        // Assign Material to TextMesh Pro Component
        //m_textMeshPro.fontSharedMaterial = Resources.Load("Fonts & Materials/LiberationSans SDF - Bevel", typeof(Material)) as Material;
        //m_textMeshPro.fontSharedMaterial.EnableKeyword("BEVEL_ON");

        // Set various font settings.
        // m_textMeshPro.fontSize = 30;

        // m_textMeshPro.alignment = TextAlignmentOptions.Center;

        //m_textMeshPro.anchorDampening = true; // Has been deprecated but under consideration for re-implementation.
        //m_textMeshPro.enableAutoSizing = true;

        //m_textMeshPro.characterSpacing = 0.2f;
        //m_textMeshPro.wordSpacing = 0.1f;

        //m_textMeshPro.enableCulling = true;
        //m_textMeshPro.enableWordWrapping = false;

        //textMeshPro.fontColor = new Color32(255, 255, 255, 255);

        //m_textMeshPro.SetText("{0:0.00}", 15.37567f);
        //Debug.Log(string.Format("{0:0.0000}", 15.37567f));
    }


    void Update()
    {
        Counter.SetText(label, m_frame % 1000);
        m_frame = S_Manager.Timer;


        if (S_Manager.Started == true)
        {
           // TextPhrase.SetText("Draw a " + S_Voice.word + " with your body!");
            AC.SetTrigger("Launch");
            AC.SetBool("PlayPhrase", true);
        }
        if (S_Manager.State == 1)
        {
            TextSession.SetText("Place the shape");
        }
        else if (S_Manager.State == 2)
        {
            TextSession.SetText("Compose with the second shape");
            //  AC.SetTrigger("NextSession");
        }
        else if (S_Manager.State == 3)
        {
            TextSession.SetText("Compose");
            //  AC.SetTrigger("NextSession");
        }
        else if (S_Manager.State == 4)
        {
            TextSession.SetText("Compose with the last shape");
            // AC.SetTrigger("NextSession");
        }
        else if (S_Manager.State == 5)
        {
            TextSession.SetText("IT'S FINISH");
            //m_frame += 1 * Time.deltaTime;
        }

    }
}


