<script>
import Changes from '../components/Changes.vue';
import Duration from './components/Duration.vue';
import { Plus, X } from 'lucide-vue-next';

export default {
    components: {
      Changes,
      Duration,
      Plus,
      X,
    },
    data () {
      return {
        current: {},
        i18n: {},
      }
    },
    methods: {
      addSlot() {
        this.hideEventChildren();
        this.current.slots.push({
          place: "",
          date: this.current.min,
          time: "20:00",
          duration: 0
        });
      },
      removeSlot(slot) {
        let index = this.current.slots.indexOf(slot)
        this.current.slots.splice(index, 1)
      },
      hideEventChildren() {
        let elements = document.getElementsByClassName('event__children');
        if (elements.length > 0) {
          elements[0].style.display = "none";
        }
      }
    },
    beforeMount() {
      this.dataset = document.getElementById('time-slots-app').dataset
      this.current = JSON.parse(this.dataset.current);
      this.i18n = JSON.parse(this.dataset.i18n);
    },
};
</script>

<template>
  <section class="vue__time-slots">
    <div class="row">
      <div class="col-xxl-4">
        <button
          class="btn btn-light mb-3 mb-xxl-0"
          v-show="current.slots.length < 30"
          @click="addSlot()">
          <Plus width="20" stroke-width="1.5" />
          {{ i18n.timeSlots.add }}
        </button>
      </div>
      <div class="col-xxl-8">
        <article v-for="slot in current.slots" class="mb-4">
          <div class="row g-2">
            <div class="col-lg-7">
              <div class="input-group">
                <input  class="form-select"
                        type="date"
                        v-model="slot.date"
                        v-show="current.min != current.max"
                        :min="current.min"
                        :max="current.max"
                        />
                <input  class="form-select"
                        type="time"
                        v-model="slot.time"
                        />
                <Duration
                        v-model="slot.duration"
                        :i18n="i18n.timeSlots.duration"
                        />
              </div>
            </div>
            <div class="col-lg-4">
              <input  id="place"
                      class="form-control"
                      data-translatable="true" 
                      v-model="slot.place"
                      type="text"
                      :placeholder="i18n.timeSlots.place.label"
                      />
            </div>
            <div class="col-lg-1">
              <a  class="btn btn-xs btn-danger w-100 h-100 d-flex align-items-center justify-content-center"
                  @click="removeSlot(slot)">
                <X /> 
              </a>
            </div>
          </div>
        </article>
      </div>
    </div>
  </section>
  <Changes  v-model="current"
            :i18n="i18n.changes"
            :endpoint="dataset.changesEndpoint" />
</template>
