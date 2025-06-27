<!-- =============================================================================
     HELLOWORLD.VUE - Interactive Hello World Component
     =============================================================================
-->

<template>
  <div class="hello-world">
    <h2>{{ msg }}</h2>
    
    <div class="counter-section">
      <p class="counter-text">
        You've clicked the button <strong>{{ count }}</strong> times
      </p>
      
      <div class="button-group">
        <button 
          @click="incrementCount" 
          class="primary-button"
          :class="{ 'celebration': isEven }"
        >
          Count is {{ count }}
        </button>
        
        <button 
          @click="resetCount" 
          class="secondary-button"
          :disabled="count === 0"
        >
          Reset
        </button>
      </div>
    </div>

    <div class="progress-section">
      <div class="progress-bar">
        <div 
          class="progress-fill" 
          :style="{ width: progressWidth + '%' }"
        ></div>
      </div>
      <p class="progress-text">
        Progress: {{ Math.min(count * 10, 100) }}%
      </p>
    </div>

    <div class="tips-section">
      <h3>💡 Tips</h3>
      <ul class="tips-list">
        <li>This component demonstrates Vue's reactivity system</li>
        <li>The Docker build process includes linting and testing</li>
        <li>HMR (Hot Module Replacement) updates this in real-time</li>
        <li>The production build will be optimized and minified</li>
      </ul>
    </div>

    <div class="api-demo" v-if="apiData">
      <h3>🌐 API Demo</h3>
      <p>Random fact: {{ apiData.text }}</p>
    </div>
  </div>
</template>

<script>
import { ref, computed, watch, onMounted } from 'vue'

export default {
  name: 'HelloWorld',
  props: {
    msg: {
      type: String,
      default: 'Hello Vue.js!'
    }
  },
  emits: ['update-count'],
  setup(props, { emit }) {
    // Reactive state
    const count = ref(0)
    const apiData = ref(null)

    // Computed properties
    const isEven = computed(() => count.value % 2 === 0)
    const progressWidth = computed(() => Math.min(count.value * 10, 100))

    // Methods
    const incrementCount = () => {
      count.value++
      if (count.value % 5 === 0) {
        console.log(`Milestone reached: ${count.value} clicks!`)
      }
    }

    const resetCount = () => {
      count.value = 0
    }

    const fetchRandomFact = async () => {
      try {
        // Using a simple API that doesn't require CORS
        const response = await fetch('https://uselessfacts.jsph.pl/random.json?language=en')
        const data = await response.json()
        apiData.value = data
      } catch (error) {
        console.log('API call failed (this is normal in Docker):', error.message)
        apiData.value = { 
          text: 'Vue.js was created by Evan You and first released in 2014!' 
        }
      }
    }

    // Watchers
    watch(count, (newCount) => {
      emit('update-count', newCount)
    })

    // Lifecycle
    onMounted(() => {
      console.log('HelloWorld component mounted with message:', props.msg)
      fetchRandomFact()
    })

    return {
      count,
      isEven,
      progressWidth,
      apiData,
      incrementCount,
      resetCount
    }
  }
}
</script>

<style scoped>
.hello-world {
  padding: 2rem;
  max-width: 600px;
  margin: 0 auto;
}

.counter-section {
  margin: 2rem 0;
}

.counter-text {
  font-size: 1.1rem;
  margin-bottom: 1.5rem;
  color: #666;
}

.button-group {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.primary-button {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.primary-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
}

.primary-button.celebration {
  animation: celebration 0.5s ease-in-out;
}

@keyframes celebration {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

.secondary-button {
  background: transparent;
  color: #646cff;
  border: 2px solid #646cff;
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.secondary-button:hover:not(:disabled) {
  background: #646cff;
  color: white;
}

.secondary-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.progress-section {
  margin: 2rem 0;
}

.progress-bar {
  width: 100%;
  height: 8px;
  background: rgba(100, 108, 255, 0.1);
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 0.5rem;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #646cff, #42b883);
  transition: width 0.3s ease;
  border-radius: 4px;
}

.progress-text {
  font-size: 0.9rem;
  color: #888;
  margin: 0;
}

.tips-section, .api-demo {
  margin: 2rem 0;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  border-left: 4px solid #646cff;
}

.tips-section h3, .api-demo h3 {
  margin-top: 0;
  color: #646cff;
}

.tips-list {
  text-align: left;
  color: #888;
  line-height: 1.6;
}

.tips-list li {
  margin: 0.5rem 0;
}

@media (max-width: 768px) {
  .hello-world {
    padding: 1rem;
  }
  
  .button-group {
    flex-direction: column;
    align-items: center;
  }
  
  .primary-button, .secondary-button {
    width: 200px;
  }
}
</style>

<!-- =============================================================================
     FEATURECARD.VUE - Reusable Feature Card Component
     =============================================================================
-->

<template>
  <div class="feature-card" @click="handleClick">
    <div class="feature-icon">{{ icon }}</div>
    <h3 class="feature-title">{{ title }}</h3>
    <p class="feature-description">{{ description }}</p>
    <div v-if="clicked" class="click-indicator">
      ✨ Clicked!
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'

export default {
  name: 'FeatureCard',
  props: {
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    },
    icon: {
      type: String,
      default: '⭐'
    }
  },
  setup() {
    const clicked = ref(false)

    const handleClick = () => {
      clicked.value = true
      setTimeout(() => {
        clicked.value = false
      }, 1000)
    }

    return {
      clicked,
      handleClick
    }
  }
}
</script>

<style scoped>
.feature-card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 1.5rem;
  transition: all 0.3s ease;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.feature-card:hover {
  transform: translateY(-5px);
  border-color: #646cff;
  box-shadow: 0 15px 35px rgba(100, 108, 255, 0.1);
}

.feature-icon {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  display: block;
}

.feature-title {
  font-size: 1.25rem;
  font-weight: 600;
  margin: 0 0 0.75rem 0;
  color: #646cff;
}

.feature-description {
  color: #888;
  line-height: 1.5;
  margin: 0;
  font-size: 0.95rem;
}

.click-indicator {
  position: absolute;
  top: 10px;
  right: 10px;
  background: #42b883;
  color: white;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-size: 0.8rem;
  font-weight: 600;
  animation: fadeInOut 1s ease-in-out;
}

@keyframes fadeInOut {
  0% { opacity: 0; transform: scale(0.8); }
  50% { opacity: 1; transform: scale(1); }
  100% { opacity: 0; transform: scale(0.8); }
}

@media (max-width: 768px) {
  .feature-card {
    padding: 1rem;
  }
  
  .feature-icon {
    font-size: 2rem;
  }
  
  .feature-title {
    font-size: 1.1rem;
  }
}
</style>