using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UISetParticleImage : MonoBehaviour
{
	private ParticleSystemRenderer m_Particle;
	private MaterialPropertyBlock m_PropertyBlock;

	public Texture particleTexture;

	private void Awake()
	{
		m_PropertyBlock = new MaterialPropertyBlock();
	}

    private void OnEnable()
    {
		m_Particle = GetComponent<ParticleSystemRenderer>();
		m_Particle.GetPropertyBlock(m_PropertyBlock);

		m_PropertyBlock.SetTexture("_MainTex", particleTexture);

		m_Particle.SetPropertyBlock(m_PropertyBlock);

		
    }

	

}
