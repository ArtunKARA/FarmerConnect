require("dotenv").config();
const express = require("express");
const api = require("./routes/index.js");
const { poolPromise } = require("./service/connection.js");
const cors = require("cors");

const app = express();
const port = process.env.PORT || 3000;
app.use(express.json());
app.use(
  cors({
    origin: "*",
  })
);

poolPromise.then(() => {
  app.listen(port, () => {
    console.log(`App started running on ${port}`);
  });
}).catch(err => {
  console.error("MSSQL bağlantısı başlatılamadı:", err);
});

app.use("/", api);

process.on("SIGINT", () => {
  poolPromise.then(pool => {
    pool.close();
    console.log("\nBağlantılar sonlandırılıyor...");
    process.exit(0);
  }).catch(err => {
    console.error("Bağlantılar kapatılırken bir hata oluştu:", err);
    process.exit(1);
  });
});
