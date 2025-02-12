<script>
import Changes from '../components/Changes.vue';
import { Plus } from 'lucide-vue-next';

export default {
    components: {
      Changes,
      Plus,
    },
    data () {
      return {
        current: {},
        i18n: {},
      }
    },
    methods: {
      addSlot() {
        this.current.slots.push({
          place: "",
          date: this.current.min,
          time: null,
          duration: null
        });
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
      <div class="col-lg-4">
        <button
          class="btn btn-light mb-3 mb-lg-0"
          @click="addSlot()">
          <Plus />
          {{ i18n.timeSlots.add }}
        </button>
        <br>{{ current }}
      </div>
      <div class="col-lg-8">
        <div class="row mb-3 d-none d-md-flex">
          <div class="col-lg-4">
            <label class="form-label" aria-label="{{ i18n.timeSlots.datetime.label }}">
              {{ i18n.timeSlots.datetime.label }}
            </label>
          </div>
          <div class="col-lg-2">
            <label class="form-label" aria-label="{{ i18n.timeSlots.duration.label }}">
              {{ i18n.timeSlots.duration.label }}
            </label>
          </div>
          <div class="col-lg-6">
            <label class="form-label mb-0" aria-label="{{ i18n.timeSlots.place.label }}">
              {{ i18n.timeSlots.place.label }}
            </label>
            <div class="form-text">{{ i18n.timeSlots.place.hint }}</div>
          </div>
        </div>
        <article v-for="slot in current.slots" class="mb-3">
          <div class="row g-3">
            <div class="col-lg-4">
              <div class="input-group">
                <input  id="date"
                        class="form-select"
                        type="date"
                        v-model="slot.date"
                        v-show="current.min != current.max"
                        :min="current.min"
                        :max="current.max"
                        />
                <input  id="time"
                        class="form-select"
                        type="time"
                        v-model="slot.time"
                        />
              </div>
            </div>
            <div class="col-lg-2">
              <select id="duration"
                      class="form-select"
                      v-model="slot.duration"
                      >
                <option value=""></option>
                <option value="1800">30mn</option>
                <option value="3600">1h</option>
                <option value="5400">1h30</option>
                <option value="7200">2h</option>
                <option value="9000">2h30</option>
                <option value="10800">3h</option>
                <option value="10800">3h30</option>
                <option value="14400">4h</option>
                <option value="18000">5h</option>
                <option value="21600">6h</option>
                <option value="25200">7h</option>
                <option value="28800">8h</option>
              </select>
            </div>
            <div class="col-lg-6">
              <input  id="place"
                      class="form-control"
                      data-translatable="true" 
                      :placeholder="i18n.timeSlots.place.label"
                      type="text"
                      v-model="slot.place"
                      />
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
