<template>
  <v-container class="fill-height">
    <v-responsive
      class="align-centerfill-height mx-auto"
      max-width="900"
    >

      <div class="text-center">
        <div class="text-h1 font-weight-light mb-n1">Instagram Downloader</div>
      </div>

      <div class="py-4" />

      <v-row>
        <v-text-field
        label="Link do Instagram"
        :value="url"></v-text-field>
        <v-btn
          @click="onSubmit"
          color="#5865f2">Baixar</v-btn>
      </v-row>
    </v-responsive>
  </v-container>
</template>

<script>
  // import cors from "cors";
  import axios from "axios";

  // const app = express();
  // app.use(express.json());
  // app.use(cors());

  export default {
    data () {
      return {
        url: "https://www.instagram.com/p/C7fHloFMVEA/?igsh=MXAwa3E1czlqZm1vMg==",
      }
    },
    methods: {
      async onSubmit() {
        videoString = await this.getMedia(this.url);
        console.log(data);
      },
      async getMedia(url) {
        const html = await axios.get(url);
        const $ = cheerio.load(html.data);
        const videoString = $("meta[property='og:video']").attr("content");
        return videoString;
      }
    }
  }
</script>
