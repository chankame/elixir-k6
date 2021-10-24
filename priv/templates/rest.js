import http from "k6/http";
import { check, sleep } from "k6";

// See https://k6.io/docs/using-k6/options/#using-options for documentation on k6 options
export const options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  let baseUrl = "<%= @url %>";
  let res = http.get(baseUrl);
  check(res, { success: (r) => r.status === 200 });
  sleep(0.3);
}
