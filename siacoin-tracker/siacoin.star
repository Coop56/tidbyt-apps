"""
Applet: Siacoin Price Tracker
Summary: Shows the current price of Siacoin.
Description: Shows the current price of Siacoin.
Author: Jeremiah Cooper (@Coop56)
"""

load("render.star", "render")
load("http.star", "http")
load("cache.star", "cache")

SIACOIN_PRICE_URL = "https://api.coingecko.com/api/v3/simple/price?ids=siacoin&vs_currencies=usd"

def main():
    rate_cached = cache.get("siacoin_rate")
    if rate_cached != None:
        print("Hit! Displaying cached data.")
        rate = float(rate_cached)
    else:
        print("Miss! Calling CoinGecko API.")
        rep = http.get(SIACOIN_PRICE_URL)
        if rep.status_code != 200:
            fail("CoinGecko request failed with status %d", rep.status_code)
        rate = rep.json()["siacoin"]["usd"]
        cache.set("siacoin_rate", str(float(rate)), ttl_seconds=240)

    return render.Root(
        render.Column(
            expanded=True,
            main_align="space_evenly",
            cross_align="center",
            children=[
                render.Row(
                    expanded=True,
                    main_align="space_evenly",
                    cross_align="center",
                    children=[
                        render.Text("SIA %f" % rate),
                    ]

                ),
                render.Row(
                    expanded=True,
                    main_align="space_evenly",
                    cross_align="center",
                    children=[
                        render.Text("USD"),
                    ]
                )
            ],
        )
    )