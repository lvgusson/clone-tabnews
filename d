[1mdiff --git a/pages/api/v1/migrations/index.js b/pages/api/v1/migrations/index.js[m
[1mindex 1c67a31..729eebd 100644[m
[1m--- a/pages/api/v1/migrations/index.js[m
[1m+++ b/pages/api/v1/migrations/index.js[m
[36m@@ -3,31 +3,42 @@[m [mimport { join } from "node:path";[m
 import database from "infra/database.js";[m
 [m
 export default async function migrations(req, res) {[m
[31m-  const dbClient = await database.getNewClient();[m
[31m-  const defaultMigrationsOptions = {[m
[31m-    dbClient: dbClient,[m
[31m-    dryRun: true,[m
[31m-    dir: join("infra", "migrations"),[m
[31m-    direction: "up",[m
[31m-    verbose: true,[m
[31m-    migrationsTable: "pgmigrations",[m
[31m-  };[m
[31m-  if (req.method === "GET") {[m
[31m-    const pendingMigrations = await migrationRunner(defaultMigrationsOptions);[m
[31m-    await dbClient.end();[m
[31m-    return res.status(200).json(pendingMigrations);[m
[32m+[m[32m  const allowedMethods = ["GET", "POST"];[m
[32m+[m[32m  if (!allowedMethods.includes(req.method)) {[m
[32m+[m[32m    return res.status(405).json({[m
[32m+[m[32m      error: `Method "${req.method}" not allowed"`,[m
[32m+[m[32m    });[m
   }[m
[32m+[m[32m  let dbClient;[m
[32m+[m[32m  try {[m
[32m+[m[32m    dbClient = await database.getNewClient();[m
[32m+[m[32m    const defaultMigrationsOptions = {[m
[32m+[m[32m      dbClient: dbClient,[m
[32m+[m[32m      dryRun: true,[m
[32m+[m[32m      dir: join("infra", "migrations"),[m
[32m+[m[32m      direction: "up",[m
[32m+[m[32m      verbose: true,[m
[32m+[m[32m      migrationsTable: "pgmigrations",[m
[32m+[m[32m    };[m
[32m+[m[32m    if (req.method === "GET") {[m
[32m+[m[32m      const pendingMigrations = await migrationRunner(defaultMigrationsOptions);[m
[32m+[m[32m      return res.status(200).json(pendingMigrations);[m
[32m+[m[32m    }[m
 [m
[31m-  if (req.method === "POST") {[m
[31m-    const migratedMigrations = await migrationRunner({[m
[31m-      ...defaultMigrationsOptions,[m
[31m-      dryRun: false,[m
[31m-    });[m
[31m-    await dbClient.end();[m
[31m-    if (migratedMigrations.length > 0) {[m
[31m-      return res.status(201).json(migratedMigrations);[m
[32m+[m[32m    if (req.method === "POST") {[m
[32m+[m[32m      const migratedMigrations = await migrationRunner({[m
[32m+[m[32m        ...defaultMigrationsOptions,[m
[32m+[m[32m        dryRun: false,[m
[32m+[m[32m      });[m
[32m+[m[32m      if (migratedMigrations.length > 0) {[m
[32m+[m[32m        return res.status(201).json(migratedMigrations);[m
[32m+[m[32m      }[m
[32m+[m[32m      return res.status(200).json(migratedMigrations);[m
     }[m
[31m-    return res.status(200).json(migratedMigrations);[m
[32m+[m[32m  } catch (error) {[m
[32m+[m[32m    console.log(error);[m
[32m+[m[32m    throw error;[m
[32m+[m[32m  } finally {[m
[32m+[m[32m    await dbClient.end();[m
   }[m
[31m-  return res.status(405).end();[m
 }[m
