import { SQL } from "bun";

export const pg: SQL = new SQL(
  "postgres://postgres:password@localhost:5432/curacare",
);

interface Condition {
  id: string;
  name: string;
  description: string;
  detail: string;
}

export async function addConditions(
  name: string,
  description?: string,
  detail?: string,
): Promise<Condition[]> {
  return pg`INSERT INTO "conditions" (name, description, detail) VALUES (${name}, ${description}, ${detail}) RETURNING *`;
}

export async function getConditionsByName(
  page: number,
  limit: number,
  query: string | null,
): Promise<Condition[]> {
  let schema = pg`SELECT * FROM "conditions" `;

  if (query) {
    const fixedQuery = `%${query.toLowerCase()}%`;
    schema = pg`${schema} WHERE LOWER(name) LIKE ${fixedQuery}`;
  }

  const offset = page * limit;
  schema = pg`${schema} LIMIT ${limit} OFFSET ${offset}`;

  return schema;
}

export async function getConditionByNameAndDescription(
  page: number,
  limit: number,
  query: string | null,
): Promise<Condition[]> {
  let schema = pg`SELECT * FROM "conditions" `;

  if (query) {
    const fixedQuery = `%${query.toLowerCase()}%`;
    schema = pg`${schema} WHERE LOWER(name) LIKE ${fixedQuery} OR LOWER(description) LIKE ${fixedQuery}`;
  }

  const offset = page * limit;
  schema = pg`${schema} LIMIT ${limit} OFFSET ${offset}`;

  return schema;
}
export async function getConditionById(id: string): Promise<Condition | null> {
  const rows: Condition[] = await pg`SELECT * FROM "conditions" WHERE id=${id}`;
  return rows[0] ?? null;
}
