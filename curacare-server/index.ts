import {
  addConditions,
  getConditionById,
  getConditionByNameAndDescription,
  pg,
} from "./utils/database";

const server = Bun.serve({
  port: 4000,
  hostname: "0.0.0.0",
  routes: {
    "/status": new Response("OK"),
    "/conditions": async (req) => {
      try {
        const url = new URL(req.url);
        const page = Number(url.searchParams.get("page"));
        const limit = Number(url.searchParams.get("limit"));
        const query = url.searchParams.get("query");
        const conditions = await getConditionByNameAndDescription(
          page,
          limit,
          query,
        );
        return Response.json({ conditions }, { status: 200 });
      } catch (err) {
        console.log(err);
        return new Response("Server Error", { status: 500 });
      }
    },
    "/conditions/:id": async (req) => {
      try {
        const id = req.params.id;
        if (id === "") {
          return new Response("Please enter id", { status: 400 });
        }
        const condition = await getConditionById(id);
        if (!condition) {
          return new Response("No conditions in database", { status: 400 });
        }
        return Response.json({ condition }, { status: 200 });
      } catch (err) {
        console.log(err);
        return new Response("Server Error", { status: 500 });
      }
    },
    "/conditions/create": {
      POST: async (req) => {
        try {
          const url = new URL(req.url);
          const name = url.searchParams.get("name");
          if (!name)
            return new Response("Please enter condition name.", {
              status: 400,
            });
          const description = url.searchParams.get("description");
          const detail = url.searchParams.get("detail");

          const newConditions = await addConditions(
            name,
            description ? description : undefined,
            detail ? detail : undefined,
          );
          return Response.json({ newConditions }, { status: 200 });
        } catch (err) {
          console.log(err);
          return new Response("Server Error", { status: 500 });
        }
      },
    },
  },
});

console.log(`Starting server at port: ${server.port}.`);

process.on("SIGINT", async () => {
  console.log("Closing database...");
  await pg.close();
  console.log("Done.");
  process.exit(0);
});
