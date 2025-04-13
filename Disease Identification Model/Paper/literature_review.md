# Literature Review: Knowledge Distillation in Plant Disease Detection

This section presents a comprehensive review of recent advancements in knowledge distillation techniques applied to plant disease detection, focusing on lightweight models, multi-level strategies, and mobile deployment.

---

## 🔬 Comparison Matrix of Distillation-Based Plant Disease Detection Papers

| **Paper Title** | **Dataset(s) Used** | **Distillation Method** | **Teacher / Student Architecture** | **Accuracy** | **Target Platform** |
|-----------------|----------------------|---------------------------|-------------------------------------|--------------|----------------------|
| **1. Low-Power Deep Learning Model for Plant Disease Detection**<br>*Musa et al., 2024 (MDPI)* | PlantVillage | Output-level KD (logit mimicry) | Teacher: VGG16<br>Student: Custom shallow CNN | 99.4% (Student)<br>99.6% (Teacher) | Edge (IoT devices) |
| **2. Improved ShuffleNetV2 with Ensemble Self-Distillation**<br>*Frontiers, 2024* | PlantVillage, AI Challenger, PlantDoc, Taiwan Tomato | Ensemble Self-Distillation (logit + feature) | Teacher: Dynamic Ensemble (ShuffleNetV2 + 3 shallow models)<br>Student: ShuffleNetV2 KD version | 95.08% (Student)<br>95.15% (Ensemble) | Edge + Flexible deployment |
| **3. PDLM-TK: Tensor Features + KD**<br>*Frontiers, 2024* | PlantVillage, AI Challenger, IP102 | Output-level KD + Graph convolution + Spatial Tensor | Teacher: ResNet18<br>Student: PDLM-TK (LRB-ST + BNF-GC) | 96.19%<br>F1: 94.94% | Edge + General robustness |
| **4. Deep Interpretable Architecture for Plant Disease Classification**<br>*Brahimi et al., 2019 (arXiv)* | PlantVillage (54K images) | Joint training / Self-distillation-style | Teacher & Student: CNNs (multitask learning) | Not specified | Interpretability & Explainability |

---

## Quick Takeaways

- **Highest Accuracy:** Musa et al. (VGG-based) – but lacks intermediate-level distillation.
- **Most Sophisticated Distillation:** Improved ShuffleNetV2 – ensemble logits + feature-level alignment.
- **Best Dataset Diversity:** PDLM-TK – covers pests and diseases across 3 datasets.
- **Most Interpretable:** Brahimi et al. – dual-network structure enhances visualization of decision regions.
- **Most Edge-Friendly:** Musa et al. and ShuffleNetV2 KD – optimized for IoT/mobile inference.

---

## Detailed Study Summaries

### 1. *Low-Power Deep Learning Model for Plant Disease Detection*  
**Musa et al., 2024 (MDPI)**

**Dataset(s):**  
- PlantVillage  
- Split: 80% training / 20% testing  

**Architecture:**  
- **Teacher:** VGG16 (~528MB, 138M params)  
- **Student:** Custom CNN (~34.3MB, >90% parameter reduction)

**Distillation:**  
- Output-level (KL Divergence + Cross-Entropy)  
- No feature-level KD

**Metrics:**  
- Accuracy: 99.4% (student), 99.6% (teacher)  
- Max power: 6.22W (tested on Jetson Nano, Pi 4)  
- GFLOPs: Not reported

**Limitations:**  
- No multi-level distillation  
- Not validated on external datasets  
- Focused only on classification

---

### 2. *Improved ShuffleNetV2 with Ensemble Self-Distillation*  
**Frontiers in Plant Science, 2024**

**Dataset(s):**  
- PlantVillage  
- AI Challenger  
- PlantDoc  
- Taiwan Tomato Dataset  
- Split: 70% training / 30% testing  
- Preprocessing: Resized to 64×64, extensive augmentation

**Architecture:**  
- **Student:** ShuffleNetV2 KD  
- **Teacher:** Dynamic ensemble of 4 subnetworks (original + 3 shallows)

**Distillation:**  
- Logit-level (KL Divergence)  
- Feature-level (L2)  
- Multi-model ensemble fusion

**Metrics:**  
- Accuracy: 95.08% (student)  
- F1-Score: 94.54%  
- Outperforms VGG16 and ResNet18  
- FLOPs: Same as base ShuffleNetV2  
- Latency on edge devices not tested

**Limitations:**  
- Fusion increases training complexity  
- No latency benchmarks  
- Not tested on new unseen datasets

---

### 3. *PDLM-TK: Tensor Features + KD*  
**Frontiers in Plant Science, 2024**

**Dataset(s):**  
- PlantVillage, AI Challenger, IP102  
- Split: 80/20

**Architecture:**  
- **Teacher:** ResNet18  
- **Student:** PDLM-TK (includes LRB-ST blocks + GCN module)

**Distillation:**  
- Output-level KD (KL divergence + Softmax temp)  
- Feature-level distillation via GCNs  
- Cross-entropy for hard labels

**Metrics:**  
- Accuracy: 96.19%  
- F1-Score: 94.94%  
- No power/latency benchmarks  
- Extensive augmentations applied

**Limitations:**  
- No mobile latency test  
- High complexity due to graph convolutions  
- Feature fusion increases training difficulty

---

### 4. *Deep Interpretable Architecture for Plant Diseases Classification*  
**Brahimi et al., 2019 (arXiv:1905.13523)**

**Dataset:**  
- PlantVillage  
- Split: Estimated 80/20  

**Architecture:**  
- Teacher & Student CNNs trained jointly  
- Uses multitask learning with shared representation layers

**Distillation:**  
- Self-distillation via joint training  
- No KL loss or soft targets  
- Representation alignment across streams

**Metrics:**  
- Accuracy only (value not provided)  
- Focus on visualization sharpness  
- No model size, latency, or GFLOPs reported

**Limitations:**  
- No deployment consideration  
- Not optimized for lightweight inference  
- Visualization-focused, not performance-driven

---

## Citations

- Musa, A., Hassan, M., Hamada, M., & Aliyu, F. (2024). *Low-Power Deep Learning Model for Plant Disease Detection Using Knowledge Distillation*. MDPI.  
- Wang et al. (2024). *An Improved ShuffleNetV2 Method Based on Ensemble Self-Distillation for Tomato Leaf Disease Recognition*. Frontiers in Plant Science.  
- Zhang et al. (2024). *PDLM-TK: A Tensor Feature and KD-Based Lightweight Model for Plant Pest Recognition*. Frontiers in Plant Science.  
- Brahimi, M., Mahmoudi, S., Boukhalfa, K., & Moussaoui, A. (2019). *Deep Interpretable Architecture for Plant Diseases Classification*. arXiv preprint arXiv:1905.13523.
