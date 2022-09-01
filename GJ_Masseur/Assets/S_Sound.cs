using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class S_Sound : MonoBehaviour
{
    //public AudioClip FunnyMusic;
    public AudioSource FunnySource;
    void Start()
    {
        
    }

    void Update()
    {
        
    }

    public void PlayFunnyMusic()
    {
        //FunnyMusic.Play
        FunnySource.Play();
    }

    public void PlayDecreaseVolume()
    {
        //FunnyMusic.Play
        FunnySource.volume=0.5f;
    }

    public void PlayIncreaseVolume()
    {
        //FunnyMusic.Play
        FunnySource.volume = 1f;
    }

}
