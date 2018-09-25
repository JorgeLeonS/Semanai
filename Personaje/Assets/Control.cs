using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Control : MonoBehaviour {

    Animator anim;
    int jumpHash;


	// Use this for initialization
	void Start () {
        anim = GetComponent<Animator>();
        jumpHash = Animator.StringToHash("jumper");
	}
	
	// Update is called once per frame
	void Update () {

        if (Input.GetKeyDown(KeyCode.Space))
        {
            anim.SetTrigger(jumpHash);
        }

	}
}
