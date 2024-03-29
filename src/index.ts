import { error, log } from "console";
import { env, exit } from "process";

import { Client, Partials, SnowflakeUtil, TextChannel } from "discord.js";
import { DateTime, Interval } from "luxon";

const { WATCH_CHANNEL } = env;

await new Client({ intents: ["Guilds"], partials: [Partials.GuildMember] })
  .on("ready", async (client) => {
    const channel = await client.channels.fetch(`${WATCH_CHANNEL}`);
    if (!channel) {
      error("No channel found");
      exit(1);
    }
    if (!(channel instanceof TextChannel)) {
      error("Select TextChannel");
      exit(1);
    }

    log("I am ready to remove all messages!");

    task(channel).catch(error);

    setInterval(() => {
      task(channel).catch(error);
    }, 1000 * 60 * 60);
  })
  .login();

async function task(channel: TextChannel) {
  const messages = await channel.messages.fetch({
    limit: 100,
    cache: false,
    before: SnowflakeUtil.generate({
      timestamp: DateTime.now()
        .setZone("Asia/Tokyo")
        .minus({ hour: 23 })
        .toMillis(),
    }).toString(),
  });
  messages
    .filter((message) => !message.pinned)
    .forEach((message) => {
      setTimeout(() => {
        message.delete().catch(console.error);
      }, Interval.fromDateTimes(DateTime.now(), DateTime.fromJSDate(message.createdAt).plus({ day: 1 })).toDuration("millisecond").milliseconds);
    });
}
