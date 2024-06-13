<template>
  <v-responsive
      class="align-center mx-auto"
      max-width="900"
    >
    <v-container class="fill-height">


      <div class="text-center">
        <div class="text-h1 font-weight-light mb-n1">Instagram Downloader</div>
      </div>

      <div class="py-4" />

      <v-row
        style="padding-top: 100px;"
      >
        <v-text-field
        label="Link do Instagram"
        height="60px"
        style="padding-right: 20px"
        type="input"
        v-model=url></v-text-field>
        <v-btn
          height="55px"
          @click="onSubmit"
          color="#5865f2">Buscar</v-btn>
      </v-row>

    </v-container>
    <v-container v-if="notFirstAccess">
      <v-card v-if="loading">
        <v-progress-circular model-value="20" :size="56" :width="9"></v-progress-circular>
      </v-card>
      <v-card v-else-if="mediaData.mediaType == 'jpg'">
        <v-row>
          <v-col
            v-for="n in mediaData.total"
            :key="n"
            class="d-flex child-flex"
            cols="4"
          >
            <v-card
              style="border-width: 0px; border-color: blue;"
              :style="mediaData.selected[n] ? 'border-width: 10px;' : 'border-width: 0px;'"
              class="mx-auto"
              :image=mediaData.mediaUrls[n]
              width="300"
              height="300"
              @click="manageSelected(n)"
            >
              <template v-slot:placeholder>
                <v-row
                  align="center"
                  class="fill-height ma-0"
                  justify="center">
                  <v-progress-circular
                    color="grey-lighten-5"
                    indeterminate
                  ></v-progress-circular>
                </v-row>
              </template>
            </v-card>
          </v-col>
        </v-row>
      </v-card>
    </v-container>
    <v-row>
      <v-container
        align="center">
        <v-card width="150px" v-if="selectedPhotos.length==1">
          <v-btn block @click="downloadSelectedPhotos">Baixar foto</v-btn>
        </v-card>
        <v-card width="300px" v-if="selectedPhotos.length>1">
          <v-btn block @click="downloadSelectedPhotos">Baixar {{ selectedPhotos.length }} fotos selecionadas</v-btn>
        </v-card>
        <v-card width="150px" v-if="mediaData.selected==true">
          <v-btn block @click="downloadSelectedVideo">Baixar video</v-btn>
        </v-card>
      </v-container>
    </v-row>
  </v-responsive>
</template>

<script>

  import axios from "axios";


  export default {
    data () {
      return {
        url: "",
        imagesData: [],
        loading: false,
        notFirstAccess: false,
        mediaData: {
          total: 0,
          mediaUrls: null,
          mediaType: '',
          selected: null,
        },
        selectedPhotos: [],
        selectedVideo: "",
        API_URL: import.meta.env.VITE_API_URL,
      }
    },
    methods: {
      async onSubmit() {
        this.selectedPhotos = []
        this.notFirstAccess = true
        console.log(this.url)
        this.url = this.url.split('?')[0]
        var resp = await this.getMedia()
        this.mediaData.total = resp.data.total
        this.mediaData.mediaType = resp.data.media_type
        this.mediaData.mediaUrls = resp.data.data
        if (this.mediaData.mediaType == 'mp4' ) {
          this.mediaData.selected = true
        } else {
          this.mediaData.selected = []
          for (let url in this.mediaData.mediaUrls){
            this.mediaData.selected.push(false)
          }
        }
      },
      async getMedia() {
        return await axios.get("https://" + this.API_URL + "/api/get_data?url=" + this.url)
      },
      manageSelected(index) {
        let selectedUrl = this.mediaData.mediaUrls[index]
        if (this.selectedPhotos.includes(selectedUrl)) {
          let index = this.selectedPhotos.indexOf(selectedUrl)
          this.selectedPhotos.splice(index, 1)
        } else {
          this.selectedPhotos.push(this.mediaData.mediaUrls[index])
        }
        this.mediaData.selected[index] = !this.mediaData.selected[index]
      },
      async downloadSelectedPhotos() {
        let date = Date.now()
        let index = 0
        for (const url of this.selectedPhotos) {
          index += 1
          let filename = "instagram_" + date + "_" + index +".jpg"
          await this.downloadWithAxios(url, filename)
        }
      },
      async downloadSelectedVideo() {
        let date = Date.now()
        const link = document.createElement("a")
        let url = this.mediaData.mediaUrls
        let filename = "video_instagram_" + date + ".mp4"
        await this.downloadWithAxios(url, filename)
      },
      async forceFileDownload(response, title) {
        const url = window.URL.createObjectURL(new Blob([response.data]))
        const link = document.createElement('a')
        link.href = url
        link.setAttribute('download', title)
        document.body.appendChild(link)
        return new Promise ((resolve) => {
          setTimeout(() => {
            link.click();
            resolve()
          }, 1000)
        })
      },
      async downloadWithAxios(url, title) {
        return await axios({
          method: 'get',
          url,
          responseType: 'arraybuffer',
        }).then(async (response) => {
            await this.forceFileDownload(response, title)
        }).catch((e) => console.log('error occured' + e))
      },
    },
  }
</script>
