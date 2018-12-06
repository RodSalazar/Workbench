using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class TimeController : MonoBehaviour {

	private Light _sunLight;
    private Transform _lightTransform;
    public AnimationCurve timeCurve;
    public AnimationCurve sunIntensityCurve;
    float time;
    public Gradient skyGradient;
    private Color _skyColor;
    public float duration = 60f;
    int hours;
    int minutes;
    public bool stopTime;

    void Awake()
    {
        _sunLight = this.GetComponent<Light>();
        _skyColor = RenderSettings.ambientLight;
        _lightTransform = _sunLight.GetComponent<Transform>();
    }    

    void Update ()
    {
        if (!stopTime)
        {
            time += Time.deltaTime / duration;

            time = timeCurve.Evaluate(time);
            if (time >= 1) time -= 1;

            hours = Mathf.FloorToInt(time * 24);
            minutes = Mathf.FloorToInt(time * 1440 - hours * 60);

            if (!stopTime)
                UpdateDayCycle();

            Debug.Log("Current Time: " + hours + ":" + minutes);
        }

        else
        {
            RenderSettings.ambientLight = skyGradient.Evaluate(Mathf.Repeat(time, 1.0f));
        }
    }

    private void UpdateDayCycle()
    {   
        _lightTransform.localEulerAngles = new Vector3(0, time * 360 + 180, 0);
        RenderSettings.ambientLight = skyGradient.Evaluate(Mathf.Repeat(time, 1.0f));
        _sunLight.intensity =  sunIntensityCurve.Evaluate(time * 24);
    }
}
