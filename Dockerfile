FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm i --legacy-peer-deps --ignore-scripts

FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules

COPY .dockerignore .dockerignore
COPY .env.example .env.example
COPY .gitignore .gitignore
COPY .env.local .env.local
COPY next-env.d.ts next-env.d.ts
COPY next.config.mjs next.config.mjs
COPY package-lock.json package-lock.json
COPY package.json package.json
COPY app app
COPY components components
COPY hooks hooks
COPY modules modules
COPY lib lib 
COPY tsconfig.json tsconfig.json

COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV production
RUN addgroup --system --gid 1001 nodejs \ 
&&  adduser --system --uid 1001 nextjs

COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /app/.env.local ./
COPY --from=builder --chown=nextjs:nodejs /app/entrypoint.sh ./entrypoint.sh

RUN ["chmod", "+x", "./entrypoint.sh"]
ENTRYPOINT ["./entrypoint.sh"]

USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
