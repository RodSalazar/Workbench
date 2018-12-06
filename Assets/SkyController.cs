using System.Collections;
using System.Collections.Generic;
using UnityEngine;

#if UNITY_EDITOR

[ExecuteInEditMode]

#endif

public class SkyController : MonoBehaviour {
	private int shaderColor;
	public Gradient skyGradient;
	public Transform sunDirection;
	private Vector3 upPlane = new Vector3 (0,-1,0);

	void Awake () {
		shaderColor = Shader.PropertyToID("_FinalColor");
		
	}
	// Update is called once per frame

	void Update () {

		//Debug.Log (sunDirection.transform.forward);

		//RenderSettings.ambientLight = skyGradient.Evaluate(Mathf.Repeat(speed * Time.time,1.0f));
		//RenderSettings.ambientLight = Vector4.one * Vector3.Dot(Transform.TransformDirection(sunDirection.transform.),upPlane);
		RenderSettings.ambientLight = skyGradient.Evaluate (Mathf.Clamp01(Vector3.Dot(sunDirection.transform.forward,upPlane)));
	}
}
