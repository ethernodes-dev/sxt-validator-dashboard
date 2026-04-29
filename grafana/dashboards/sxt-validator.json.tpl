{
  "uid": "sxt-val-v4",
  "title": "SXT Validator Dashboard",
  "description": "Space and Time (SXT Chain) validator monitoring",
  "tags": [
    "sxt",
    "validator",
    "substrate",
    "space-and-time"
  ],
  "timezone": "browser",
  "refresh": "1m",
  "time": {
    "from": "now-3h",
    "to": "now"
  },
  "schemaVersion": 41,
  "version": 79,
  "style": "dark",
  "panels": [
    {
      "title": "⬢ Protocol overview",
      "type": "row",
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "panels": [
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Latest block produced by the network (head of the chain).\n\nSource: substrate_block_height{status='best'} (produced by BABE).\nBABE is Substrate's block production mechanism; 'best' blocks can still be reverted in short reorgs until GRANDPA finalizes them.",
          "gridPos": {
            "x": 0,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "substrate_block_height{status=\"best\",job=\"sxt-node\"}",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">BEST BLOCK</p>\n  <p class=\"sxt-num sxt-num--xl\" data-raw=\"{{value}}\">{{value}}</p>\n</div>\n<img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9-]/g,'');if(r){el.textContent=parseInt(r,10).toLocaleString('en-US');}})})();this.remove()\" style=\"display:none\">\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Latest finalized block (irreversible tip confirmed by GRANDPA).\n\nSource: substrate_block_height{status='finalized'} (finalized by GRANDPA).\nGRANDPA is Substrate's finality gadget; once ≥2/3 validators vote a block, it and all ancestors become provably final.",
          "gridPos": {
            "x": 3,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "substrate_block_height{status=\"finalized\",job=\"sxt-node\"}",
              "refId": "A",
              "legendFormat": "value",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">FINALIZED</p>\n  <p class=\"sxt-num sxt-num--xl\" data-raw=\"{{value}}\">{{value}}</p>\n</div>\n<img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9-]/g,'');if(r){el.textContent=parseInt(r,10).toLocaleString('en-US');}})})();this.remove()\" style=\"display:none\">\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Number of blocks between 'best' (BABE head) and 'finalized' (GRANDPA tip).\n\nSource: sxt_finality_lag_blocks = best_height - finalized_height.\nHealthy: 2-3 blocks (normal GRANDPA round). Warn: >5. Danger: >20 (GRANDPA stalling — possible validator connectivity or consensus issue).",
          "gridPos": {
            "x": 6,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_finality_lag_blocks",
              "refId": "A",
              "legendFormat": "value",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">FINALITY LAG</p>\n  <p class=\"sxt-num sxt-num--xl\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "locale",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Whether the local node is still catching up with the network.\n\nSource: sxt_is_syncing (from system_health.isSyncing RPC).\n'Synced' = caught up to best block. 'Syncing' = still importing historical blocks; validation duties must NOT be performed until fully synced.",
          "gridPos": {
            "x": 9,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_is_syncing",
              "refId": "A",
              "legendFormat": "value",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <div style=\"display:flex; align-items:center; gap:8px; justify-content:center;\">\n    <span class=\"sxt-status-dot\" data-status=\"{{#if (eq value \"0\")}}ok{{else}}warn{{/if}}\"></span>\n    <p class=\"sxt-label\" style=\"margin:0;\">NODE SYNC</p>\n  </div>\n  <p class=\"sxt-num sxt-num--xl\" style=\"margin:0;\">{{#if (eq value \"0\")}}Synced{{else}}Syncing{{/if}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-status-dot { display:inline-block; width:8px; height:8px; border-radius:50%; background: var(--sxt-text-dim); }\n.sxt-status-dot[data-status=\"ok\"]   { background: var(--sxt-success); box-shadow: 0 0 6px var(--sxt-success); }\n.sxt-status-dot[data-status=\"warn\"] { background: var(--sxt-warning); box-shadow: 0 0 6px var(--sxt-warning); }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "On-chain runtime specification version.\n\nSource: sxt_runtime_spec_version.\nIncremented on runtime upgrades via governance. Mismatch with your client's supported spec can cause block execution failures.",
          "gridPos": {
            "x": 12,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_runtime_spec_version",
              "refId": "A",
              "legendFormat": "value",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">RUNTIME SPEC</p>\n  <p class=\"sxt-num sxt-num--xl\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "locale",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Transactions currently in the local node's transaction pool waiting to be included.\n\nSource: sxt_pending_extrinsics.\nGrowing pool can indicate network congestion or blocked propagation.",
          "gridPos": {
            "x": 15,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_pending_extrinsics",
              "refId": "A",
              "legendFormat": "value",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">PENDING EXT.</p>\n  <p class=\"sxt-num sxt-num--xl\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "locale",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Current staking era number.\n\nSource: sxt_staking_current_era.\nAn era is the unit of time over which nominators and validators earn rewards. Eras roll over automatically based on session lengths defined by governance.",
          "gridPos": {
            "x": 18,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_staking_current_era",
              "refId": "A",
              "legendFormat": "value",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">ERA</p>\n  <p class=\"sxt-num sxt-num--xl\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "locale",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Current BABE epoch index.\n\nSource: sxt_network_babe_epoch_index.\nBABE epochs are the unit of validator rotation for block production duties. Shorter than eras; multiple epochs make up one era.",
          "gridPos": {
            "x": 21,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_network_babe_epoch_index",
              "refId": "A",
              "legendFormat": "value",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">EPOCH</p>\n  <p class=\"sxt-num sxt-num--xl\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "locale",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Current GRANDPA finality voting round.\n\nSource: sxt_grandpa_round.\nA round is one attempt by validators to finalize a set of blocks via pre-vote + pre-commit. Increments on every successful finalization.",
          "gridPos": {
            "x": 0,
            "y": 5,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_grandpa_round",
              "refId": "A",
              "legendFormat": "value",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">GRANDPA ROUND</p>\n  <p class=\"sxt-num sxt-num--xl\" data-raw=\"{{value}}\">{{value}}</p>\n</div>\n<img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9-]/g,'');if(r){el.textContent=parseInt(r,10).toLocaleString('en-US');}})})();this.remove()\" style=\"display:none\">\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Progress through the current staking era, 0-100%.\n\nSource: sxt_staking_era_progress × 100.\nAt 100%, the era closes and rewards are distributed; a new era starts.",
          "gridPos": {
            "x": 4,
            "y": 5,
            "w": 10,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_staking_era_progress * 100",
              "refId": "A",
              "legendFormat": "value",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card\" style=\"display:flex; flex-direction:column; justify-content:center; gap:12px; height:100%;\">\n  <div class=\"sxt-spread\">\n    <p class=\"sxt-label\" style=\"margin:0;\">ERA PROGRESS</p>\n    <p class=\"sxt-num sxt-num--md\" style=\"margin:0;\">{{value}}%</p>\n  </div>\n  <div class=\"sxt-progress-track\">\n    <div class=\"sxt-progress-fill\" style=\"width: {{value}}%;\"></div>\n  </div>\n</div>\n<style>\n.sxt-progress-track { width:100%; height:10px; background: rgba(111,77,128,0.2); border-radius:5px; overflow:hidden; }\n.sxt-progress-fill { height:100%; background: linear-gradient(90deg, var(--sxt-electric-purple) 0%, var(--sxt-neon-magenta) 60%, #CC0AAC 100%); border-radius:5px; transition: width 0.5s ease; box-shadow: 0 0 12px rgba(204,10,172,0.6); }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 1
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Progress through the current BABE epoch, 0-100%.\n\nSource: sxt_network_babe_epoch_progress × 100.\nShorter cycle than eras; used for rotating block authorship duties.",
          "gridPos": {
            "x": 14,
            "y": 5,
            "w": 10,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_network_babe_epoch_progress * 100",
              "refId": "A",
              "legendFormat": "value",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card\" style=\"display:flex; flex-direction:column; justify-content:center; gap:12px; height:100%;\">\n  <div class=\"sxt-spread\">\n    <p class=\"sxt-label\" style=\"margin:0;\">EPOCH PROGRESS</p>\n    <p class=\"sxt-num sxt-num--md\" style=\"margin:0;\">{{value}}%</p>\n  </div>\n  <div class=\"sxt-progress-track\">\n    <div class=\"sxt-progress-fill\" style=\"width: {{value}}%;\"></div>\n  </div>\n</div>\n<style>\n.sxt-progress-track { width:100%; height:10px; background: rgba(111,77,128,0.2); border-radius:5px; overflow:hidden; }\n.sxt-progress-fill { height:100%; background: linear-gradient(90deg, var(--sxt-electric-purple) 0%, var(--sxt-neon-magenta) 60%, #CC0AAC 100%); border-radius:5px; transition: width 0.5s ease; box-shadow: 0 0 12px rgba(204,10,172,0.6); }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "javascript",
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true,
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            }
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 1
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        }
      ],
      "description": "Chain-wide state: blocks, finality, era/epoch, runtime."
    },
    {
      "title": "⬢ Network economics",
      "type": "row",
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 1
      },
      "panels": [
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Current SXT token price in USD.\n\nSource: sxt_token_price_usd (CoinGecko free API, scraped every 5m)\nUsed as multiplier across all USD conversions in the dashboard.",
          "gridPos": {
            "x": 0,
            "y": 1,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_token_price_usd",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">SXT / USD</p>\n  <p class=\"sxt-num sxt-num--xl\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "currencyUSD",
              "decimals": 6
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "24-hour price change in percent.\n\nSource: sxt_token_price_change_24h_pct (CoinGecko)\nGreen when positive, red when negative.",
          "gridPos": {
            "x": 4,
            "y": 1,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_token_price_change_24h_pct",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <div style=\"display:flex; align-items:center; gap:8px; justify-content:center;\">\n    <span class=\"sxt-status-dot\" data-status=\"{{#if (contains value \"-\")}}danger{{else}}ok{{/if}}\"></span>\n    <p class=\"sxt-label\" style=\"margin:0;\">24H CHANGE</p>\n  </div>\n  <p class=\"sxt-num sxt-num--xl\" style=\"margin:0;\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-status-dot { display:inline-block; width:8px; height:8px; border-radius:50%; background: var(--sxt-text-dim); }\n.sxt-status-dot[data-status=\"ok\"]     { background: var(--sxt-success); box-shadow: 0 0 6px var(--sxt-success); }\n.sxt-status-dot[data-status=\"danger\"] { background: var(--sxt-danger);  box-shadow: 0 0 6px var(--sxt-danger); }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "percent",
              "decimals": 2
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Total market capitalization of SXT in USD.\n\nSource: sxt_token_market_cap_usd (CoinGecko)\nCalculated as circulating supply × current price.",
          "gridPos": {
            "x": 8,
            "y": 1,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_token_market_cap_usd",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">MARKET CAP</p>\n  <p class=\"sxt-num sxt-num--xl\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "currencyUSD",
              "decimals": 2
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "24-hour trading volume across all exchanges, in USD.\n\nSource: sxt_token_volume_24h_usd (CoinGecko)\nLiquidity indicator: low volume can signal exit difficulty.",
          "gridPos": {
            "x": 12,
            "y": 1,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_token_volume_24h_usd",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">24H VOLUME</p>\n  <p class=\"sxt-num sxt-num--xl\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "currencyUSD",
              "decimals": 2
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Total stake bonded in the current staking era, expressed in USD.\n\nSource: sxt_staking_era_total_stake * current price\nProxy for total capital secured by SXT's consensus.",
          "gridPos": {
            "x": 16,
            "y": 1,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_staking_era_total_stake_usd",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">TOTAL STAKE (USD)</p>\n  <p class=\"sxt-num sxt-num--xl\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "currencyUSD",
              "decimals": 2
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Total rewards distributed in the last completed era, in USD.\n\nSource: sxt_staking_last_era_reward * current price\nEra rewards are minted and split across active validators by era points.",
          "gridPos": {
            "x": 20,
            "y": 1,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_staking_last_era_reward_usd",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">NETWORK ERA REWARD</p>\n  <p class=\"sxt-num sxt-num--xl\">{{value}}</p>\n</div>\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "currencyUSD",
              "decimals": 2
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "volkovlabs-echarts-panel",
          "title": "Price history",
          "datasource": "ClickHouse",
          "description": "SXT token price history (USD) from CoinGecko, stored in ClickHouse",
          "gridPos": {
            "x": 0,
            "y": 5,
            "w": 24,
            "h": 10
          },
          "targets": [
            {
              "rawSql": "SELECT timestamp as time, price_usd FROM sxt.price_history ORDER BY timestamp",
              "format": 1,
              "editorType": "sql",
              "queryType": "timeseries",
              "refId": "A"
            }
          ],
          "options": {
            "editor": {
              "format": "full",
              "height": 600
            },
            "getOption": "const series = context.panel.data.series.map((s) => {\n  const sData = s.fields.find((f) => f.type === \"number\");\n  const sTime = s.fields.find((f) => f.type === \"time\");\n  if (!sData || !sTime) return null;\n  const values = sData.values.buffer || sData.values;\n  const times  = sTime.values.buffer || sTime.values;\n  return {\n    name: \"Price (USD)\",\n    type: \"line\",\n    smooth: true,\n    showSymbol: false,\n    lineStyle: {\n      width: 2,\n      color: {\n        type: \"linear\", x: 0, y: 0, x2: 1, y2: 0,\n        colorStops: [\n          { offset: 0, color: \"#5000BF\" },\n          { offset: 1, color: \"#CC0AAC\" },\n        ],\n      },\n    },\n    areaStyle: {\n      color: {\n        type: \"linear\", x: 0, y: 0, x2: 0, y2: 1,\n        colorStops: [\n          { offset: 0, color: \"rgba(204, 10, 172, 0.35)\" },\n          { offset: 1, color: \"rgba(80, 0, 191, 0.02)\" },\n        ],\n      },\n    },\n    data: times.map((t, i) => [t, values[i]]),\n  };\n}).filter(Boolean);\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 20, bottom: 30, containLabel: true },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.95)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => \"$\" + Number(v).toFixed(6),\n  },\n  xAxis: {\n    type: \"time\",\n    axisLine:  { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false },\n  },\n  yAxis: {\n    type: \"value\",\n    scale: true,\n    axisLine:  { show: false },\n    axisTick:  { show: false },\n    axisLabel: {\n      color: \"#A090B5\",\n      fontFamily: \"JetBrains Mono\",\n      fontSize: 10,\n      formatter: (v) => \"$\" + v.toFixed(6),\n    },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } },\n  },\n  series: series,\n};\n",
            "map": "",
            "renderer": "canvas",
            "themeEditor": {
              "config": {},
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "dataset": [],
              "series": []
            }
          },
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          }
        }
      ],
      "description": "Token price, market cap, volume and network-level USD metrics."
    },
    {
      "title": "⬢ Validators — global stats",
      "type": "row",
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 2
      },
      "panels": [
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Number of validators currently producing blocks in the active set.\n\nSource: sxt_network_active_validators\nBounded above by the target validator count (see Max validators card).",
          "gridPos": {
            "x": 0,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_network_active_validators",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">ACTIVE VALIDATORS</p>\n  <p class=\"sxt-num sxt-num--xl\" data-raw=\"{{value}}\">{{value}}</p>\n</div>\n<img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');if(r){var n=parseFloat(r);if(!isNaN(n))el.textContent=n.toLocaleString('en-US',{maximumFractionDigits:2});}})})();this.remove()\" style=\"display:none\">\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Validators registered and bonded but not in the active set.\n\nSource: sxt_staking_waiting_validators\nThey compete by stake weight for active slots each era.",
          "gridPos": {
            "x": 3,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_staking_waiting_validators",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">WAITING</p>\n  <p class=\"sxt-num sxt-num--xl\" data-raw=\"{{value}}\">{{value}}</p>\n</div>\n<img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');if(r){var n=parseFloat(r);if(!isNaN(n))el.textContent=n.toLocaleString('en-US',{maximumFractionDigits:2});}})})();this.remove()\" style=\"display:none\">\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Total number of unique nominator accounts delegating to validators.\n\nSource: sxt_staking_total_nominators\nHigher count = wider stake distribution = healthier decentralisation.",
          "gridPos": {
            "x": 6,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_staking_total_nominators",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">NOMINATORS</p>\n  <p class=\"sxt-num sxt-num--xl\" data-raw=\"{{value}}\">{{value}}</p>\n</div>\n<img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');if(r){var n=parseFloat(r);if(!isNaN(n))el.textContent=n.toLocaleString('en-US',{maximumFractionDigits:2});}})})();this.remove()\" style=\"display:none\">\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Total SXT bonded for consensus in the current era.\n\nSource: sxt_staking_era_total_stake\nSum of all nominators' stake across all active validators.",
          "gridPos": {
            "x": 18,
            "y": 1,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_staking_era_total_stake",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">TOTAL STAKE (SXT)</p>\n  <p class=\"sxt-num sxt-num--xl\" data-raw=\"{{value}}\">{{value}}</p>\n</div>\n<img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');if(r){var n=parseFloat(r);if(!isNaN(n))el.textContent=n.toLocaleString('en-US',{maximumFractionDigits:2});}})})();this.remove()\" style=\"display:none\">\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Reward pool distributed in the last completed era, in SXT.\n\nSource: sxt_staking_last_era_reward\nSplit across validators proportionally to era points earned.",
          "gridPos": {
            "x": 12,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_staking_last_era_reward",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">LAST ERA REWARD</p>\n  <p class=\"sxt-num sxt-num--xl\" data-raw=\"{{value}}\">{{value}}</p>\n</div>\n<img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');if(r){var n=parseFloat(r);if(!isNaN(n))el.textContent=n.toLocaleString('en-US',{maximumFractionDigits:2});}})})();this.remove()\" style=\"display:none\">\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 1
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Total era points generated network-wide in the current era.\n\nSource: sxt_staking_era_total_reward_points\nEra points are earned by block authorship and validation duties.",
          "gridPos": {
            "x": 15,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_staking_era_total_reward_points",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">ERA REWARD POINTS</p>\n  <p class=\"sxt-num sxt-num--xl\" data-raw=\"{{value}}\">{{value}}</p>\n</div>\n<img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');if(r){var n=parseFloat(r);if(!isNaN(n))el.textContent=n.toLocaleString('en-US',{maximumFractionDigits:2});}})})();this.remove()\" style=\"display:none\">\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "marcusolsson-dynamictext-panel",
          "title": "",
          "datasource": "Prometheus",
          "description": "Target size of the active validator set, defined by governance.\n\nSource: sxt_staking_target_validator_count\nCurrently 18. Validators above this count are pushed to the waiting pool.",
          "gridPos": {
            "x": 9,
            "y": 1,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_staking_target_validator_count",
              "refId": "A",
              "legendFormat": "",
              "instant": true,
              "range": false
            }
          ],
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\">\n  <p class=\"sxt-label\">MAX VALIDATORS</p>\n  <p class=\"sxt-num sxt-num--xl\" data-raw=\"{{value}}\">{{value}}</p>\n</div>\n<img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');if(r){var n=parseFloat(r);if(!isNaN(n))el.textContent=n.toLocaleString('en-US',{maximumFractionDigits:2});}})})();this.remove()\" style=\"display:none\">\n<style>\n.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:10px; height:100%; }\n.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }\n</style>\n",
            "contentPartials": [],
            "defaultContent": "",
            "editors": [
              "text"
            ],
            "everyRow": true,
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "afterRenderEnabled": false,
              "beforeRender": "",
              "beforeRenderEnabled": false
            },
            "renderMode": "everyRow",
            "status": {
              "mode": "default"
            },
            "styles": "",
            "wrap": true
          },
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ]
        },
        {
          "type": "volkovlabs-echarts-panel",
          "title": "Stake per validator",
          "datasource": "Prometheus",
          "description": "Treemap showing each validator's total stake as a tile, sized by SXT bonded.\n\nSource: sxt_validator_total_stake{address=...}\nVisual check for stake concentration.",
          "gridPos": {
            "x": 0,
            "y": 13,
            "w": 12,
            "h": 14
          },
          "targets": [
            {
              "refId": "A",
              "expr": "sxt_validator_total_stake",
              "range": false,
              "instant": true
            }
          ],
          "options": {
            "editor": {
              "format": "full",
              "height": 600
            },
            "getOption": "const frame = context.panel.data.series[0];\nif (!frame || !frame.fields) return { title: { text: 'No data', textStyle: { color: '#6F4D80' }, left: 'center', top: 'middle' } };\n\n// Extract validator addresses (from labels) and stake values\nconst valueField = frame.fields.find(f => f.type === 'number');\nif (!valueField) return {};\nconst values = valueField.values.buffer || valueField.values;\nconst labels = valueField.labels || {};\nconst valueLabels = valueField.config?.displayNameFromDS || '';\n\n// Each series in the frame has its own validator label. Since all validators\n// return a single value each, we have multiple series in frame.\nconst series = context.panel.data.series;\nconst data = series.map((s, i) => {\n  const numField = s.fields.find(f => f.type === 'number');\n  if (!numField) return null;\n  const v = (numField.values.buffer || numField.values)[0];\n  // Label: try to find validator address in labels\n  const lbls = numField.labels || {};\n  const addr = lbls.validator || lbls.address || lbls.account || lbls.id ||\n               Object.values(lbls)[0] || s.refId || ('v' + i);\n  return {\n    name: addr.length > 8 ? addr.slice(0, 6) + '…' + addr.slice(-4) : addr,\n    fullName: addr,\n    value: Number(v),\n  };\n}).filter(Boolean).sort((a, b) => b.value - a.value);\n\n// Build color scale magenta->purple based on rank\nconst colorFor = (i, total) => {\n  const t = i / Math.max(1, total - 1);\n  // interpolate from magenta (#CC0AAC) to purple (#5000BF)\n  const r1=0xCC, g1=0x0A, b1=0xAC;\n  const r2=0x50, g2=0x00, b2=0xBF;\n  const r=Math.round(r1 + (r2-r1)*t);\n  const g=Math.round(g1 + (g2-g1)*t);\n  const b=Math.round(b1 + (b2-b1)*t);\n  return 'rgb(' + r + ',' + g + ',' + b + ')';\n};\n\nconst totalStake = data.reduce((a, b) => a + b.value, 0);\n\nreturn {\n  backgroundColor: 'transparent',\n  tooltip: {\n    backgroundColor: 'rgba(36, 9, 53, 0.95)',\n    borderColor: '#5000BF',\n    borderWidth: 1,\n    textStyle: { color: '#E6E6E6', fontFamily: 'Inter, sans-serif', fontSize: 11 },\n    formatter: (info) => {\n      const pct = ((info.value / totalStake) * 100).toFixed(2);\n      return '<div style=\"padding:2px 0;\">'\n        + '<div style=\"color:#CC0AAC; font-weight:600; margin-bottom:4px;\">' + (info.data.fullName || info.name) + '</div>'\n        + '<div>Stake: <b>' + Number(info.value).toLocaleString('en-US') + '</b></div>'\n        + '<div>Share: <b>' + pct + '%</b></div>'\n        + '</div>';\n    },\n  },\n  series: [{\n    type: 'treemap',\n    data: data.map((d, i) => ({\n      ...d,\n      itemStyle: { color: colorFor(i, data.length) },\n    })),\n    roam: false,\n    nodeClick: false,\n    breadcrumb: { show: false },\n    label: {\n      show: true,\n      formatter: '{b}',\n      color: '#E6E6E6',\n      fontFamily: 'JetBrains Mono, monospace',\n      fontSize: 10,\n      fontWeight: 600,\n      textShadowColor: 'rgba(0,0,0,0.8)',\n      textShadowBlur: 4,\n    },\n    upperLabel: { show: false },\n    itemStyle: {\n      borderColor: 'rgba(16, 2, 23, 0.9)',\n      borderWidth: 2,\n      gapWidth: 2,\n    },\n    emphasis: {\n      itemStyle: {\n        shadowBlur: 20,\n        shadowColor: 'rgba(204, 10, 172, 0.6)',\n      },\n      label: { fontSize: 13 },\n    },\n    levels: [{\n      itemStyle: {\n        borderColor: 'rgba(16, 2, 23, 0.9)',\n        borderWidth: 2,\n        gapWidth: 2,\n      },\n    }],\n  }],\n};\n",
            "map": "",
            "renderer": "canvas",
            "themeEditor": {
              "config": {},
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "dataset": [],
              "series": []
            }
          },
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          }
        },
        {
          "type": "volkovlabs-echarts-panel",
          "title": "Era points per validator",
          "datasource": "Prometheus",
          "description": "Horizontal bar ranking showing era points earned so far in the current era.\n\nSource: sxt_validator_era_points{address=...}\nValidators below the network average may be under-performing.",
          "gridPos": {
            "x": 12,
            "y": 13,
            "w": 12,
            "h": 14
          },
          "targets": [
            {
              "refId": "A",
              "expr": "sxt_validator_era_points",
              "range": false,
              "instant": true
            }
          ],
          "options": {
            "editor": {
              "format": "full",
              "height": 600
            },
            "getOption": "const series = context.panel.data.series;\nconst data = series.map((s, i) => {\n  const numField = s.fields.find(f => f.type === 'number');\n  if (!numField) return null;\n  const v = (numField.values.buffer || numField.values)[0];\n  const lbls = numField.labels || {};\n  const addr = lbls.validator || lbls.address || lbls.account || lbls.id ||\n               Object.values(lbls)[0] || s.refId || ('v' + i);\n  return {\n    name: addr.length > 8 ? addr.slice(0, 6) + '…' + addr.slice(-4) : addr,\n    fullName: addr,\n    value: Number(v),\n  };\n}).filter(Boolean).sort((a, b) => a.value - b.value);  // ascending for horizontal bar\n\nreturn {\n  backgroundColor: 'transparent',\n  grid: { left: 110, right: 30, top: 10, bottom: 30, containLabel: false },\n  tooltip: {\n    trigger: 'item',\n    backgroundColor: 'rgba(36, 9, 53, 0.95)',\n    borderColor: '#5000BF',\n    borderWidth: 1,\n    textStyle: { color: '#E6E6E6', fontFamily: 'Inter' },\n    formatter: (p) => '<b style=\"color:#CC0AAC\">' + (p.data.fullName || p.name) + '</b><br/>Era points: <b>' + Number(p.value).toLocaleString('en-US') + '</b>',\n  },\n  xAxis: {\n    type: 'value',\n    axisLine:  { show: false },\n    axisTick:  { show: false },\n    axisLabel: { color: '#A090B5', fontFamily: 'JetBrains Mono', fontSize: 9 },\n    splitLine: { lineStyle: { color: 'rgba(58, 24, 87, 0.4)', type: 'dashed' } },\n  },\n  yAxis: {\n    type: 'category',\n    data: data.map(d => d.name),\n    axisLine:  { lineStyle: { color: '#3A1857' } },\n    axisTick:  { show: false },\n    axisLabel: { color: '#A090B5', fontFamily: 'JetBrains Mono', fontSize: 9 },\n  },\n  series: [{\n    type: 'bar',\n    data: data.map(d => ({ value: d.value, fullName: d.fullName })),\n    itemStyle: {\n      color: {\n        type: 'linear', x: 0, y: 0, x2: 1, y2: 0,\n        colorStops: [\n          { offset: 0, color: '#5000BF' },\n          { offset: 1, color: '#CC0AAC' },\n        ],\n      },\n      borderRadius: [0, 3, 3, 0],\n    },\n    emphasis: {\n      itemStyle: { shadowBlur: 10, shadowColor: 'rgba(204, 10, 172, 0.6)' },\n    },\n    barWidth: '70%',\n  }],\n};\n",
            "map": "",
            "renderer": "canvas",
            "themeEditor": {
              "config": {},
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "dataset": [],
              "series": []
            }
          },
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          }
        },
        {
          "type": "volkovlabs-echarts-panel",
          "title": "All validators",
          "datasource": "Prometheus",
          "description": "All registered validators with key metrics. Click column headers to sort.",
          "gridPos": {
            "x": 0,
            "y": 27,
            "w": 24,
            "h": 14
          },
          "targets": [
            {
              "expr": "sxt_validator_total_stake",
              "refId": "Stake",
              "instant": true,
              "range": false,
              "legendFormat": ""
            },
            {
              "expr": "sxt_validator_own_stake",
              "refId": "OwnStake",
              "instant": true,
              "range": false,
              "legendFormat": ""
            },
            {
              "expr": "sxt_validator_commission",
              "refId": "Commission",
              "instant": true,
              "range": false,
              "legendFormat": ""
            },
            {
              "expr": "sxt_validator_nominator_count",
              "refId": "Nominators",
              "instant": true,
              "range": false,
              "legendFormat": ""
            },
            {
              "expr": "sxt_validator_era_points",
              "refId": "Points",
              "instant": true,
              "range": false,
              "legendFormat": ""
            },
            {
              "expr": "sxt_validator_active",
              "refId": "Active",
              "instant": true,
              "range": false,
              "legendFormat": ""
            }
          ],
          "options": {
            "editor": {
              "format": "auto"
            },
            "getOption": "\nconst s = context.panel.data.series;\nconst W = context.panel.chart.getWidth();\n\nif (!s || !s.length) {\n  return {backgroundColor:'transparent', graphic:{elements:[\n    {type:'text', left:'center', top:'center', style:{text:'No validator data', fill:'#6F4D80', fontSize:14}}\n  ]}};\n}\n\n// Merge 6 Prometheus series by validator address label\n// Each series has refId: Stake/OwnStake/Commission/Nominators/Points/Active\nconst byValidator = new Map();\nconst refToKey = {\n  'Stake': 'stake', 'OwnStake': 'ownStake', 'Commission': 'commission',\n  'Nominators': 'nominators', 'Points': 'points', 'Active': 'active',\n};\n\ns.forEach(serie => {\n  const key = refToKey[serie.refId];\n  if (!key) return;\n  const numField = serie.fields.find(f => f.type === 'number');\n  if (!numField) return;\n  const v = (numField.values.buffer || numField.values)[0];\n  const lbls = numField.labels || {};\n  const addr = lbls.validator || lbls.address || lbls.account || lbls.id ||\n               Object.values(lbls)[0];\n  if (!addr) return;\n  if (!byValidator.has(addr)) byValidator.set(addr, {addr});\n  byValidator.get(addr)[key] = Number(v);\n});\n\nconst rows = Array.from(byValidator.values()).map(r => ({\n  addr: r.addr,\n  stake: r.stake ?? 0,\n  ownStake: r.ownStake ?? 0,\n  commission: r.commission ?? 0,\n  nominators: r.nominators ?? 0,\n  points: r.points ?? 0,\n  active: r.active ?? 0,\n}));\n\nif (!rows.length) {\n  return {backgroundColor:'transparent', graphic:{elements:[\n    {type:'text', left:'center', top:'center', style:{text:'No validator data', fill:'#6F4D80', fontSize:14}}\n  ]}};\n}\n\n// Stats for header\nconst activeN = rows.filter(r => r.active === 1).length;\nconst waitingN = rows.filter(r => r.active === 0).length;\nconst totalStake = rows.reduce((a,r) => a + r.stake, 0);\nconst totalNominators = rows.reduce((a,r) => a + r.nominators, 0);\nconst avgCommission = rows.reduce((a,r) => a + r.commission, 0) / rows.length;\n\nconst fmt = n => Number(n).toLocaleString('en-US', {maximumFractionDigits: 0});\nconst fmtPct = n => n.toFixed(1) + '%';\n\nconst shortAddr = a => a.length > 14 ? a.slice(0,8) + '…' + a.slice(-4) : a;\n\nconst dom = context.panel.chart.getDom();\ndom._sxtRows = rows;\ndom._sxtSortCol = dom._sxtSortCol || 'stake';\ndom._sxtSortDir = dom._sxtSortDir || 'desc';\n\nfunction buildTable(sortCol, sortDir) {\n  const sorted = [...dom._sxtRows];\n  sorted.sort((a, b) => {\n    let cmp;\n    if (sortCol === 'addr') cmp = a.addr.localeCompare(b.addr);\n    else cmp = (a[sortCol] || 0) - (b[sortCol] || 0);\n    return sortDir === 'asc' ? cmp : -cmp;\n  });\n\n  const maxStake = Math.max(...sorted.map(r => r.stake));\n  const maxPoints = Math.max(...sorted.map(r => r.points));\n\n  const arrow = col => sortCol === col\n    ? (sortDir === 'asc' ? ' ▲' : ' ▼')\n    : ' ▴▾';\n  const headColor = col => sortCol === col ? '#CC0AAC' : '#A090B5';\n\n  // Header with summary stats\n  let h = '<div style=\"display:flex;gap:18px;padding:10px 16px;border-bottom:1px solid #3A1857;font-size:11px;color:#A090B5;font-family:Inter,sans-serif;\">';\n  h += '<span><span style=\"color:#00C853\">●</span> Active: <b style=\"color:#E6E6E6\">'+activeN+'</b></span>';\n  if (waitingN > 0) h += '<span><span style=\"color:#6F4D80\">●</span> Waiting: <b style=\"color:#E6E6E6\">'+waitingN+'</b></span>';\n  h += '<span style=\"margin-left:auto\">Total stake: <b style=\"color:#CC0AAC\">'+fmt(totalStake)+'</b> SXT</span>';\n  h += '<span>Nominators: <b style=\"color:#E6E6E6\">'+fmt(totalNominators)+'</b></span>';\n  h += '<span>Avg commission: <b style=\"color:#E6E6E6\">'+fmtPct(avgCommission)+'</b></span>';\n  h += '<span style=\"color:#6F4D80\">Total: '+sorted.length+'</span>';\n  h += '</div>';\n\n  // Table\n  h += '<table style=\"width:100%;border-collapse:collapse;font-size:12px;color:#E6E6E6;\">';\n  h += '<thead style=\"position:sticky;top:0;z-index:1;\">';\n  h += '<tr style=\"background:#100217;\">';\n  h += '<th data-sort=\"addr\"       style=\"cursor:pointer;user-select:none;text-align:left;padding:8px 14px;color:'+headColor('addr')+';font-size:10px;font-weight:600;letter-spacing:1px;border-bottom:1px solid #3A1857;\">VALIDATOR'+arrow('addr')+'</th>';\n  h += '<th data-sort=\"active\"     style=\"cursor:pointer;user-select:none;text-align:center;padding:8px 14px;color:'+headColor('active')+';font-size:10px;font-weight:600;letter-spacing:1px;border-bottom:1px solid #3A1857;\">STATUS'+arrow('active')+'</th>';\n  h += '<th data-sort=\"stake\"      style=\"cursor:pointer;user-select:none;text-align:right;padding:8px 14px;color:'+headColor('stake')+';font-size:10px;font-weight:600;letter-spacing:1px;border-bottom:1px solid #3A1857;\">TOTAL STAKE'+arrow('stake')+'</th>';\n  h += '<th data-sort=\"ownStake\"   style=\"cursor:pointer;user-select:none;text-align:right;padding:8px 14px;color:'+headColor('ownStake')+';font-size:10px;font-weight:600;letter-spacing:1px;border-bottom:1px solid #3A1857;\">OWN STAKE'+arrow('ownStake')+'</th>';\n  h += '<th data-sort=\"commission\" style=\"cursor:pointer;user-select:none;text-align:right;padding:8px 14px;color:'+headColor('commission')+';font-size:10px;font-weight:600;letter-spacing:1px;border-bottom:1px solid #3A1857;\">COMMISSION'+arrow('commission')+'</th>';\n  h += '<th data-sort=\"nominators\" style=\"cursor:pointer;user-select:none;text-align:right;padding:8px 14px;color:'+headColor('nominators')+';font-size:10px;font-weight:600;letter-spacing:1px;border-bottom:1px solid #3A1857;\">NOMINATORS'+arrow('nominators')+'</th>';\n  h += '<th data-sort=\"points\"     style=\"cursor:pointer;user-select:none;text-align:right;padding:8px 14px;color:'+headColor('points')+';font-size:10px;font-weight:600;letter-spacing:1px;border-bottom:1px solid #3A1857;\">ERA POINTS'+arrow('points')+'</th>';\n  h += '</tr></thead><tbody>';\n\n  for (let i = 0; i < sorted.length; i++) {\n    const r = sorted[i];\n    const bg = i % 2 === 0 ? 'transparent' : 'rgba(204,10,172,0.025)';\n    const stakePct = Math.min(100, (r.stake / maxStake) * 100);\n    const pointsPct = Math.min(100, (r.points / maxPoints) * 100);\n    const statusLabel = r.active === 1 ? 'Active' : 'Waiting';\n    const statusColor = r.active === 1 ? '#00C853' : '#6F4D80';\n    const statusIcon = r.active === 1 ? '●' : '○';\n\n    h += '<tr style=\"background:'+bg+'\" onmouseover=\"this.style.background=\\'rgba(204,10,172,0.08)\\'\" onmouseout=\"this.style.background=\\''+bg+'\\'\">';\n    h += '<td style=\"padding:7px 14px;font-family:JetBrains Mono,monospace;font-size:11px;color:#E6E6E6;\">'+shortAddr(r.addr)+'</td>';\n    h += '<td style=\"padding:7px 14px;text-align:center;color:'+statusColor+';font-size:11px;font-weight:500;\">'+statusIcon+' '+statusLabel+'</td>';\n\n    h += '<td style=\"padding:7px 14px;text-align:right;\"><div style=\"display:flex;align-items:center;justify-content:flex-end;gap:10px;\">';\n    h += '<div style=\"width:70px;height:4px;background:rgba(58,24,87,0.4);border-radius:2px;overflow:hidden;\"><div style=\"width:'+stakePct+'%;height:100%;background:linear-gradient(90deg,#5000BF,#CC0AAC);border-radius:2px;\"></div></div>';\n    h += '<span style=\"color:#E6E6E6;font-family:JetBrains Mono,monospace;font-size:11px;font-weight:600;min-width:100px;text-align:right;\">'+fmt(r.stake)+'</span></div></td>';\n\n    h += '<td style=\"padding:7px 14px;text-align:right;font-family:JetBrains Mono,monospace;font-size:11px;color:#A090B5;\">'+fmt(r.ownStake)+'</td>';\n    h += '<td style=\"padding:7px 14px;text-align:right;font-family:JetBrains Mono,monospace;font-size:11px;color:#A090B5;\">'+fmtPct(r.commission)+'</td>';\n    h += '<td style=\"padding:7px 14px;text-align:right;font-family:JetBrains Mono,monospace;font-size:11px;color:#A090B5;\">'+fmt(r.nominators)+'</td>';\n\n    h += '<td style=\"padding:7px 14px;text-align:right;\"><div style=\"display:flex;align-items:center;justify-content:flex-end;gap:10px;\">';\n    h += '<div style=\"width:60px;height:4px;background:rgba(58,24,87,0.4);border-radius:2px;overflow:hidden;\"><div style=\"width:'+pointsPct+'%;height:100%;background:#CC0AAC;border-radius:2px;\"></div></div>';\n    h += '<span style=\"color:#E6E6E6;font-family:JetBrains Mono,monospace;font-size:11px;font-weight:600;min-width:60px;text-align:right;\">'+fmt(r.points)+'</span></div></td>';\n\n    h += '</tr>';\n  }\n  h += '</tbody></table>';\n  return h;\n}\n\ndom._sxtBuildTable = buildTable;\nconst html = buildTable(dom._sxtSortCol, dom._sxtSortDir);\nconst _hash = html.length + '_' + dom._sxtSortCol + dom._sxtSortDir;\nif (dom._lastSxtHash === _hash) return {backgroundColor:'transparent'};\ndom._lastSxtHash = _hash;\n\nsetTimeout(() => {\n  let wrap = dom.querySelector('.sxt-val-wrap');\n  if (!wrap) {\n    wrap = document.createElement('div');\n    wrap.className = 'sxt-val-wrap';\n    wrap.style.cssText = 'position:absolute;inset:0;overflow-y:auto;overflow-x:hidden;z-index:10;scrollbar-width:thin;scrollbar-color:#3A1857 transparent;';\n    dom.appendChild(wrap);\n  }\n  wrap.innerHTML = html;\n\n  dom._sxtAttachSort = function(w) {\n    w.querySelectorAll('[data-sort]').forEach(th => {\n      th.addEventListener('click', function() {\n        const col = this.getAttribute('data-sort');\n        if (dom._sxtSortCol === col) {\n          dom._sxtSortDir = dom._sxtSortDir === 'asc' ? 'desc' : 'asc';\n        } else {\n          dom._sxtSortCol = col;\n          dom._sxtSortDir = col === 'addr' ? 'asc' : 'desc';\n        }\n        w.innerHTML = dom._sxtBuildTable(dom._sxtSortCol, dom._sxtSortDir);\n        dom._lastSxtHash = null;\n        dom._sxtAttachSort(w);\n      });\n    });\n  };\n  dom._sxtAttachSort(wrap);\n}, 0);\n\nreturn {backgroundColor:'transparent'};\n",
            "map": "none",
            "renderer": "canvas",
            "themeEditor": {
              "config": "{}",
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "dataset": [],
              "series": []
            },
            "padding": 0
          },
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          }
        },
        {
          "type": "volkovlabs-echarts-panel",
          "title": "Stake distribution",
          "datasource": "Prometheus",
          "description": "Pie/donut showing relative stake share per validator in USD terms.\n\nSource: sxt_validator_total_stake_usd\nNakamoto coefficient quick-view: how many top validators control >33%.",
          "gridPos": {
            "x": 0,
            "y": 41,
            "w": 12,
            "h": 12
          },
          "targets": [
            {
              "refId": "A",
              "expr": "sxt_validator_total_stake_usd",
              "range": false,
              "instant": true
            }
          ],
          "options": {
            "editor": {
              "format": "full",
              "height": 600
            },
            "getOption": "const series = context.panel.data.series;\nconst data = series.map((s, i) => {\n  const numField = s.fields.find(f => f.type === 'number');\n  if (!numField) return null;\n  const v = (numField.values.buffer || numField.values)[0];\n  const lbls = numField.labels || {};\n  const addr = lbls.validator || lbls.address || lbls.account || lbls.id ||\n               Object.values(lbls)[0] || s.refId || ('v' + i);\n  return {\n    name: addr.length > 8 ? addr.slice(0, 6) + '…' + addr.slice(-4) : addr,\n    fullName: addr,\n    value: Number(v),\n  };\n}).filter(Boolean).sort((a, b) => b.value - a.value);\n\n// Top 10 + \"Others\" aggregation\nconst TOP = 10;\nlet pieData = data;\nif (data.length > TOP) {\n  const top = data.slice(0, TOP);\n  const others = data.slice(TOP).reduce((sum, d) => sum + d.value, 0);\n  pieData = [...top, { name: 'Others (' + (data.length - TOP) + ')', fullName: 'Others', value: others }];\n}\n\nconst colorFor = (i, total) => {\n  const t = i / Math.max(1, total - 1);\n  const r1=0xCC, g1=0x0A, b1=0xAC;\n  const r2=0x50, g2=0x00, b2=0xBF;\n  const r=Math.round(r1 + (r2-r1)*t);\n  const g=Math.round(g1 + (g2-g1)*t);\n  const b=Math.round(b1 + (b2-b1)*t);\n  return 'rgb(' + r + ',' + g + ',' + b + ')';\n};\n\nreturn {\n  backgroundColor: 'transparent',\n  tooltip: {\n    trigger: 'item',\n    backgroundColor: 'rgba(36, 9, 53, 0.95)',\n    borderColor: '#5000BF',\n    borderWidth: 1,\n    textStyle: { color: '#E6E6E6', fontFamily: 'Inter' },\n    formatter: (p) => '<b style=\"color:#CC0AAC\">' + (p.data.fullName || p.name) + '</b><br/>Stake: <b>$' + Number(p.value).toLocaleString('en-US') + '</b><br/>Share: <b>' + p.percent + '%</b>',\n  },\n  series: [{\n    type: 'pie',\n    radius: ['40%', '70%'],\n    center: ['50%', '50%'],\n    avoidLabelOverlap: true,\n    itemStyle: {\n      borderColor: 'rgba(16, 2, 23, 0.9)',\n      borderWidth: 2,\n    },\n    label: {\n      show: true,\n      color: '#E6E6E6',\n      fontFamily: 'JetBrains Mono, monospace',\n      fontSize: 9,\n      formatter: '{b}',\n    },\n    labelLine: { lineStyle: { color: '#6F4D80' } },\n    emphasis: {\n      itemStyle: { shadowBlur: 15, shadowColor: 'rgba(204, 10, 172, 0.6)' },\n      label: { fontSize: 11, fontWeight: 'bold' },\n    },\n    data: pieData.map((d, i) => ({\n      ...d,\n      itemStyle: { color: colorFor(i, pieData.length) },\n    })),\n  }],\n};\n",
            "map": "",
            "renderer": "canvas",
            "themeEditor": {
              "config": {},
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "dataset": [],
              "series": []
            }
          },
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          }
        },
        {
          "type": "volkovlabs-echarts-panel",
          "title": "Era rewards history",
          "datasource": "ClickHouse",
          "description": "Historical SXT rewards distributed per era across the entire network.\n\nSource: sxt.v_era_rewards (ClickHouse view, computed from ErasValidatorReward).\nSteady = healthy network inflation; drops indicate missed rewards.",
          "gridPos": {
            "x": 12,
            "y": 41,
            "w": 12,
            "h": 12
          },
          "targets": [
            {
              "refId": "A",
              "rawSql": "SELECT toString(era) as era, network_reward FROM sxt.v_era_rewards ORDER BY era",
              "format": 1
            }
          ],
          "options": {
            "editor": {
              "format": "full",
              "height": 600
            },
            "getOption": "const frame = context.panel.data.series[0];\nif (!frame) return { title: { text: 'No data', left: 'center', top: 'middle', textStyle: { color: '#6F4D80' } } };\n\nconst eraField = frame.fields.find(f => f.name === 'era');\nconst rewardField = frame.fields.find(f => f.name === 'network_reward' || f.type === 'number');\nif (!eraField || !rewardField) return {};\n\nconst eras = eraField.values.buffer || eraField.values;\nconst rewards = rewardField.values.buffer || rewardField.values;\n\nreturn {\n  backgroundColor: 'transparent',\n  grid: { left: 60, right: 20, top: 20, bottom: 40, containLabel: true },\n  tooltip: {\n    trigger: 'axis',\n    backgroundColor: 'rgba(36, 9, 53, 0.95)',\n    borderColor: '#5000BF',\n    borderWidth: 1,\n    textStyle: { color: '#E6E6E6', fontFamily: 'Inter' },\n    formatter: (params) => {\n      const p = params[0];\n      return '<b style=\"color:#CC0AAC\">Era ' + p.name + '</b><br/>Reward: <b>' + Number(p.value).toLocaleString('en-US') + '</b>';\n    },\n    axisPointer: { type: 'shadow', shadowStyle: { color: 'rgba(204, 10, 172, 0.1)' } },\n  },\n  xAxis: {\n    type: 'category',\n    data: eras.map(e => String(e)),\n    axisLine:  { lineStyle: { color: '#3A1857' } },\n    axisTick:  { show: false },\n    axisLabel: { color: '#A090B5', fontFamily: 'JetBrains Mono', fontSize: 9 },\n  },\n  yAxis: {\n    type: 'value',\n    axisLine:  { show: false },\n    axisTick:  { show: false },\n    axisLabel: { color: '#A090B5', fontFamily: 'JetBrains Mono', fontSize: 9 },\n    splitLine: { lineStyle: { color: 'rgba(58, 24, 87, 0.4)', type: 'dashed' } },\n  },\n  series: [{\n    type: 'bar',\n    data: Array.from(rewards).map(v => Number(v)),\n    itemStyle: {\n      color: {\n        type: 'linear', x: 0, y: 0, x2: 0, y2: 1,\n        colorStops: [\n          { offset: 0, color: '#CC0AAC' },\n          { offset: 1, color: '#5000BF' },\n        ],\n      },\n      borderRadius: [3, 3, 0, 0],\n    },\n    emphasis: {\n      itemStyle: { shadowBlur: 10, shadowColor: 'rgba(204, 10, 172, 0.7)' },\n    },\n    barWidth: '60%',\n  }],\n};\n",
            "map": "",
            "renderer": "canvas",
            "themeEditor": {
              "config": {},
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "dataset": [],
              "series": []
            }
          },
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          }
        },
        {
          "type": "volkovlabs-echarts-panel",
          "title": "Network stake changes per era",
          "datasource": "ClickHouse",
          "description": "Per-era change in total network stake (sum across all validators).\n\nSource: sxt.v_delegation_changes (ClickHouse view, derived from delegation_snapshots). Computed as delta of sum(total_stake) between consecutive eras.\n\nNote: this is the NET aggregate change. Internal redistributions among validators (A loses 1k SXT, B gains 1k SXT) cancel out at this level — this panel reflects new stake entering or leaving the protocol as a whole, not churn between validators.",
          "gridPos": {
            "x": 0,
            "y": 53,
            "w": 24,
            "h": 10
          },
          "targets": [
            {
              "refId": "A",
              "rawSql": "SELECT toString(era) as era, inflows, outflows, net_change FROM sxt.v_delegation_changes ORDER BY era",
              "format": 1
            }
          ],
          "options": {
            "editor": {
              "format": "full",
              "height": 600
            },
            "getOption": "const frame = context.panel.data.series[0];\nif (!frame) return { title: { text: 'No data', left: 'center', top: 'middle', textStyle: { color: '#6F4D80' } } };\n\nconst eraField    = frame.fields.find(f => f.name === 'era');\nconst inflowsF    = frame.fields.find(f => f.name === 'inflows');\nconst outflowsF   = frame.fields.find(f => f.name === 'outflows');\nconst netChangeF  = frame.fields.find(f => f.name === 'net_change');\nif (!eraField) return {};\n\nconst eras     = eraField.values.buffer || eraField.values;\nconst inflows  = inflowsF  ? (inflowsF.values.buffer  || inflowsF.values)  : [];\nconst outflows = outflowsF ? (outflowsF.values.buffer || outflowsF.values) : [];\nconst netCh    = netChangeF? (netChangeF.values.buffer|| netChangeF.values): [];\n\nreturn {\n  backgroundColor: 'transparent',\n  legend: {\n    data: ['Inflows', 'Outflows', 'Net change'],\n    top: 5,\n    textStyle: { color: '#A090B5', fontFamily: 'Inter', fontSize: 10 },\n    itemWidth: 10, itemHeight: 10,\n  },\n  grid: { left: 60, right: 20, top: 35, bottom: 40, containLabel: true },\n  tooltip: {\n    trigger: 'axis',\n    backgroundColor: 'rgba(36, 9, 53, 0.95)',\n    borderColor: '#5000BF',\n    borderWidth: 1,\n    textStyle: { color: '#E6E6E6', fontFamily: 'Inter' },\n    axisPointer: { type: 'shadow', shadowStyle: { color: 'rgba(204, 10, 172, 0.1)' } },\n  },\n  xAxis: {\n    type: 'category',\n    data: Array.from(eras).map(e => String(e)),\n    axisLine:  { lineStyle: { color: '#3A1857' } },\n    axisTick:  { show: false },\n    axisLabel: { color: '#A090B5', fontFamily: 'JetBrains Mono', fontSize: 9 },\n  },\n  yAxis: {\n    type: 'value',\n    axisLine:  { show: false },\n    axisTick:  { show: false },\n    axisLabel: { color: '#A090B5', fontFamily: 'JetBrains Mono', fontSize: 9 },\n    splitLine: { lineStyle: { color: 'rgba(58, 24, 87, 0.4)', type: 'dashed' } },\n  },\n  series: [\n    {\n      name: 'Inflows',\n      type: 'bar',\n      data: Array.from(inflows).map(v => Number(v)),\n      itemStyle: { color: '#00C853', borderRadius: [2, 2, 0, 0] },\n      barGap: '10%', barWidth: '28%',\n    },\n    {\n      name: 'Outflows',\n      type: 'bar',\n      data: Array.from(outflows).map(v => -Math.abs(Number(v))),\n      itemStyle: { color: '#ef4444', borderRadius: [2, 2, 0, 0] },\n      barWidth: '28%',\n    },\n    {\n      name: 'Net change',\n      type: 'line',\n      data: Array.from(netCh).map(v => Number(v)),\n      smooth: true,\n      lineStyle: { color: '#CC0AAC', width: 2 },\n      itemStyle: { color: '#CC0AAC' },\n      symbol: 'circle',\n      symbolSize: 5,\n    },\n  ],\n};\n",
            "map": "",
            "renderer": "canvas",
            "themeEditor": {
              "config": {},
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "dataset": [],
              "series": []
            }
          },
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          }
        },
        {
          "title": "Estimated APR per validator",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 5,
            "w": 12,
            "h": 8
          },
          "targets": [
            {
              "expr": "sxt_validator_estimated_apr",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#5000BF\",\"#CC0AAC\",\"#00BCD4\",\"#CC0AAC\",\"#7C4DFF\",\n                 \"#B388FF\",\"#7C4DFF\",\"#B388FF\",\"#A090B5\",\"#B388FF\",\n                 \"#BA55D3\",\"#FF77AA\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.labels && numField.labels.address)\n              || (numField.config && numField.config.displayNameFromDS)\n              || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({\n    name: lbl, type: \"line\", smooth: true, showSymbol: false, sampling: \"lttb\",\n    lineStyle: { width: 1.8, color: color },\n    itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } },\n    data: points,\n  });\n});\n\n// === Estado de hover compartido entre re-renders ===\n// Lo colgamos del chart instance; sobrevive a setOption pero no a creación de chart nuevo.\nconst chart = context.panel.chart;\nif (chart && !chart.__sxtHoverInit) {\n  chart.__sxtHoverIndex = -1;\n  chart.__sxtHoverInit = true;\n  chart.on(\"mouseover\", (params) => {\n    if (params && typeof params.seriesIndex === \"number\" && params.seriesIndex !== chart.__sxtHoverIndex) {\n      chart.__sxtHoverIndex = params.seriesIndex;\n      // Trigger re-render del tooltip si ya está abierto\n      try { chart.setOption({}, { lazyUpdate: true }); } catch(e) {}\n    }\n  });\n  chart.on(\"mouseout\", () => {\n    if (chart.__sxtHoverIndex !== -1) {\n      chart.__sxtHoverIndex = -1;\n      try { chart.setOption({}, { lazyUpdate: true }); } catch(e) {}\n    }\n  });\n}\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 70, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    pageTextStyle: { color: \"#A090B5\" }, pageIconColor: \"#5000BF\",\n    pageIconInactiveColor: \"#3A1857\" },\n  tooltip: {\n    trigger: \"axis\",\n    appendToBody: true,\n    confine: false,\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    padding: [8, 12],\n    extraCssText: \"max-width: 320px; max-height: 400px; overflow-y: auto; box-shadow: 0 4px 20px rgba(80,0,191,0.3); border-radius: 4px;\",\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\", fontSize: 11 },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    order: \"valueDesc\",\n    formatter: (params) => {\n      if (!params || !params.length) return \"\";\n      const hoverIdx = (chart && typeof chart.__sxtHoverIndex === \"number\") ? chart.__sxtHoverIndex : -1;\n      const ts = new Date(params[0].axisValue);\n      const tsStr = ts.toLocaleString(\"en-US\", {\n        month: \"short\", day: \"2-digit\", hour: \"2-digit\", minute: \"2-digit\"\n      });\n      let html = '<div style=\"font-family:JetBrains Mono,monospace; font-size:10px; color:#A090B5; margin-bottom:6px; border-bottom:1px solid #3A1857; padding-bottom:4px;\">' + tsStr + '</div>';\n      params.forEach((p) => {\n        const isFocused = (hoverIdx >= 0 && p.seriesIndex === hoverIdx);\n        const formatted = ((v) => Number(v).toLocaleString(\"en-US\",{minimumFractionDigits:2,maximumFractionDigits:2})+\" %\")(p.value[1]);\n        const nameColor = isFocused ? \"#CC0AAC\" : \"#E6E6E6\";\n        const weight = isFocused ? \"700\" : \"400\";\n        const bg = isFocused ? \"background:rgba(204,10,172,0.18); border-radius:3px; padding:3px 6px; margin:2px -6px;\" : \"padding:2px 0;\";\n        html += '<div style=\"display:flex; justify-content:space-between; align-items:center; gap:12px; ' + bg + '\">' +\n          '<span style=\"display:flex; align-items:center; gap:6px;\">' +\n            '<span style=\"display:inline-block; width:8px; height:8px; border-radius:50%; background:' + p.color + ';\"></span>' +\n            '<span style=\"color:' + nameColor + '; font-weight:' + weight + ';\">' + p.seriesName + '</span>' +\n          '</span>' +\n          '<span style=\"color:' + nameColor + '; font-family:JetBrains Mono,monospace; font-weight:' + weight + ';\">' + formatted + '</span>' +\n        '</div>';\n      });\n      return html;\n    },\n  },\n  xAxis: { type: \"time\", axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true, axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n      formatter: (v) => v.toFixed(1)+\" %\" },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          },
          "description": "Estimated annual percentage return for each validator, based on recent era rewards.\n\nSource: sxt_validator_estimated_apr\nComputed from last era reward, scaled to a year. Subject to commission and uptime."
        },
        {
          "title": "Stake per validator over time",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 12,
            "y": 5,
            "w": 12,
            "h": 8
          },
          "targets": [
            {
              "expr": "sxt_validator_total_stake",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#5000BF\",\"#CC0AAC\",\"#00BCD4\",\"#CC0AAC\",\"#7C4DFF\",\n                 \"#B388FF\",\"#7C4DFF\",\"#B388FF\",\"#A090B5\",\"#B388FF\",\n                 \"#BA55D3\",\"#FF77AA\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.labels && numField.labels.address)\n              || (numField.config && numField.config.displayNameFromDS)\n              || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({\n    name: lbl, type: \"line\", smooth: true, showSymbol: false, sampling: \"lttb\",\n    lineStyle: { width: 1.8, color: color },\n    itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } },\n    data: points,\n  });\n});\n\n// === Estado de hover compartido entre re-renders ===\n// Lo colgamos del chart instance; sobrevive a setOption pero no a creación de chart nuevo.\nconst chart = context.panel.chart;\nif (chart && !chart.__sxtHoverInit) {\n  chart.__sxtHoverIndex = -1;\n  chart.__sxtHoverInit = true;\n  chart.on(\"mouseover\", (params) => {\n    if (params && typeof params.seriesIndex === \"number\" && params.seriesIndex !== chart.__sxtHoverIndex) {\n      chart.__sxtHoverIndex = params.seriesIndex;\n      // Trigger re-render del tooltip si ya está abierto\n      try { chart.setOption({}, { lazyUpdate: true }); } catch(e) {}\n    }\n  });\n  chart.on(\"mouseout\", () => {\n    if (chart.__sxtHoverIndex !== -1) {\n      chart.__sxtHoverIndex = -1;\n      try { chart.setOption({}, { lazyUpdate: true }); } catch(e) {}\n    }\n  });\n}\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 70, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    pageTextStyle: { color: \"#A090B5\" }, pageIconColor: \"#5000BF\",\n    pageIconInactiveColor: \"#3A1857\" },\n  tooltip: {\n    trigger: \"axis\",\n    appendToBody: true,\n    confine: false,\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    padding: [8, 12],\n    extraCssText: \"max-width: 320px; max-height: 400px; overflow-y: auto; box-shadow: 0 4px 20px rgba(80,0,191,0.3); border-radius: 4px;\",\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\", fontSize: 11 },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    order: \"valueDesc\",\n    formatter: (params) => {\n      if (!params || !params.length) return \"\";\n      const hoverIdx = (chart && typeof chart.__sxtHoverIndex === \"number\") ? chart.__sxtHoverIndex : -1;\n      const ts = new Date(params[0].axisValue);\n      const tsStr = ts.toLocaleString(\"en-US\", {\n        month: \"short\", day: \"2-digit\", hour: \"2-digit\", minute: \"2-digit\"\n      });\n      let html = '<div style=\"font-family:JetBrains Mono,monospace; font-size:10px; color:#A090B5; margin-bottom:6px; border-bottom:1px solid #3A1857; padding-bottom:4px;\">' + tsStr + '</div>';\n      params.forEach((p) => {\n        const isFocused = (hoverIdx >= 0 && p.seriesIndex === hoverIdx);\n        const formatted = ((v) => Number(v).toLocaleString(\"en-US\",{maximumFractionDigits:0})+\" SXT\")(p.value[1]);\n        const nameColor = isFocused ? \"#CC0AAC\" : \"#E6E6E6\";\n        const weight = isFocused ? \"700\" : \"400\";\n        const bg = isFocused ? \"background:rgba(204,10,172,0.18); border-radius:3px; padding:3px 6px; margin:2px -6px;\" : \"padding:2px 0;\";\n        html += '<div style=\"display:flex; justify-content:space-between; align-items:center; gap:12px; ' + bg + '\">' +\n          '<span style=\"display:flex; align-items:center; gap:6px;\">' +\n            '<span style=\"display:inline-block; width:8px; height:8px; border-radius:50%; background:' + p.color + ';\"></span>' +\n            '<span style=\"color:' + nameColor + '; font-weight:' + weight + ';\">' + p.seriesName + '</span>' +\n          '</span>' +\n          '<span style=\"color:' + nameColor + '; font-family:JetBrains Mono,monospace; font-weight:' + weight + ';\">' + formatted + '</span>' +\n        '</div>';\n      });\n      return html;\n    },\n  },\n  xAxis: { type: \"time\", axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true, axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n      formatter: (v) => Number(v).toLocaleString(\"en-US\",{maximumFractionDigits:0}) },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          },
          "description": "Time-series view of each validator's total stake (SXT) evolution.\n\nSource: sxt_validator_total_stake, range query\nGrowth trends, slashing events, or nominator exits become visible here."
        }
      ],
      "description": "All validators on-chain: totals, stake distribution, era points, era rewards history, delegation flows, full sortable table."
    },
    {
      "title": "⬢ Validator economics",
      "type": "row",
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 3
      },
      "panels": [
        {
          "title": "★ Latest era reward",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 9,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_validator_estimated_era_reward{address=\"${validator}\"}",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">LATEST ERA REWARD (SXT)</p><p class=\"sxt-num sxt-num--md sxt-fmt-era-reward\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-era-reward[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');var n=parseFloat(r);if(isNaN(n)){el.textContent='—';return;}el.textContent=Math.round(n).toLocaleString('en-US');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Estimated reward for this validator in the current era, in SXT.\n\nSource: sxt_validator_estimated_era_reward{address=${validator}}\nExtrapolated from era points accrued so far. Finalizes at era end."
        },
        {
          "title": "★ APR",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 3,
            "y": 9,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_validator_estimated_apr{address=\"${validator}\"}",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 2
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">APR</p><p class=\"sxt-num sxt-num--md\">{{value}} %</p></div><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Annualized percentage return for this validator, net of commission.\n\nSource: sxt_validator_estimated_apr{address=${validator}}\nEstimate only — actual yield depends on uptime and era point performance."
        },
        {
          "title": "★ 84-day commission",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "ClickHouse",
          "gridPos": {
            "x": 6,
            "y": 9,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "rawSql": "SELECT sum(commission_sxt) AS value FROM sxt.v_validator_earnings WHERE validator_name = '${validator}'",
              "refId": "A",
              "format": 1,
              "editorType": "sql",
              "queryType": "table"
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">84-DAY COMMISSION (SXT)</p><p class=\"sxt-num sxt-num--md sxt-fmt-84-comm\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-84-comm[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');var n=parseFloat(r);if(isNaN(n)){el.textContent='—';return;}el.textContent=Math.round(n).toLocaleString('en-US');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Total commission earned over the last 84 eras (~21 days at 6h/era).\n\nSource: sxt.v_validator_earnings (ClickHouse view, sum of commission_sxt)\nReflects revenue collected from nominators' rewards."
        },
        {
          "title": "★ 84-day total earned",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "ClickHouse",
          "gridPos": {
            "x": 9,
            "y": 9,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "rawSql": "SELECT sum(total_earned_sxt) AS value FROM sxt.v_validator_earnings WHERE validator_name = '${validator}'",
              "refId": "A",
              "format": 1,
              "editorType": "sql",
              "queryType": "table"
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">84-DAY TOTAL (SXT)</p><p class=\"sxt-num sxt-num--md sxt-fmt-84-total\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-84-total[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');var n=parseFloat(r);if(isNaN(n)){el.textContent='—';return;}el.textContent=Math.round(n).toLocaleString('en-US');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Total rewards (commission + own yield) for the validator over the last 84 eras.\n\nSource: sxt.v_validator_earnings (sum of total_earned_sxt)\nGross income before operational costs."
        },
        {
          "title": "★ Monthly commission",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "ClickHouse",
          "gridPos": {
            "x": 12,
            "y": 9,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "rawSql": "SELECT comm_sxt AS value FROM sxt.v_validator_monthly WHERE validator_name = '${validator}' ORDER BY month DESC LIMIT 1",
              "refId": "A",
              "format": 1,
              "editorType": "sql",
              "queryType": "table"
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">MONTHLY COMMISSION (SXT)</p><p class=\"sxt-num sxt-num--md sxt-fmt-m-comm\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-m-comm[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');var n=parseFloat(r);if(isNaN(n)){el.textContent='—';return;}el.textContent=Math.round(n).toLocaleString('en-US');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Commission earned in the current calendar month, in SXT.\n\nSource: sxt.v_validator_monthly (ClickHouse view)\nReset at the start of each month; compare across months in the bar chart below."
        },
        {
          "title": "★ Monthly own yield",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "ClickHouse",
          "gridPos": {
            "x": 15,
            "y": 9,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "rawSql": "SELECT yield_sxt AS value FROM sxt.v_validator_monthly WHERE validator_name = '${validator}' ORDER BY month DESC LIMIT 1",
              "refId": "A",
              "format": 1,
              "editorType": "sql",
              "queryType": "table"
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">MONTHLY OWN YIELD (SXT)</p><p class=\"sxt-num sxt-num--md sxt-fmt-m-yield\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-m-yield[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');var n=parseFloat(r);if(isNaN(n)){el.textContent='—';return;}el.textContent=Math.round(n).toLocaleString('en-US');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Own-stake yield (non-commission portion) for the current month, in SXT.\n\nSource: sxt.v_validator_monthly (yield_sxt column)\nProportional to the validator's own bonded stake."
        },
        {
          "title": "★ Monthly total",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "ClickHouse",
          "gridPos": {
            "x": 18,
            "y": 9,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "rawSql": "SELECT total_sxt AS value FROM sxt.v_validator_monthly WHERE validator_name = '${validator}' ORDER BY month DESC LIMIT 1",
              "refId": "A",
              "format": 1,
              "editorType": "sql",
              "queryType": "table"
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">MONTHLY TOTAL (SXT)</p><p class=\"sxt-num sxt-num--md sxt-fmt-m-total\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-m-total[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');var n=parseFloat(r);if(isNaN(n)){el.textContent='—';return;}el.textContent=Math.round(n).toLocaleString('en-US');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Sum of commission + own yield for the current month, in SXT.\n\nSource: sxt.v_validator_monthly (total_sxt column)\nPrimary top-line monthly revenue figure."
        },
        {
          "title": "★ Monthly total (USD)",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "ClickHouse",
          "gridPos": {
            "x": 21,
            "y": 9,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "rawSql": "SELECT total_sxt * (SELECT price_usd FROM sxt.price_history ORDER BY timestamp DESC LIMIT 1) AS value FROM sxt.v_validator_monthly WHERE validator_name = '${validator}' ORDER BY month DESC LIMIT 1",
              "refId": "A",
              "format": 1,
              "editorType": "sql",
              "queryType": "table"
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">MONTHLY TOTAL (USD)</p><p class=\"sxt-num sxt-num--md sxt-fmt-m-usd\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-m-usd[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9.-]/g,'');var n=parseFloat(r);if(isNaN(n)){el.textContent='—';return;}el.textContent=n.toLocaleString('en-US',{style:'currency',currency:'USD',maximumFractionDigits:0});})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Monthly total SXT earnings converted to USD at current price.\n\nSource: sxt.v_validator_monthly.total_sxt × sxt.price_history (latest)\nVolatile with SXT price; the SXT-denominated figure is more stable."
        },
        {
          "title": "Earnings per era",
          "type": "volkovlabs-echarts-panel",
          "datasource": "ClickHouse",
          "gridPos": {
            "x": 0,
            "y": 13,
            "w": 24,
            "h": 10
          },
          "targets": [
            {
              "rawSql": "SELECT toString(era) AS era, commission_sxt, own_yield_sxt, commission_sxt * (SELECT price_usd FROM sxt.price_history ORDER BY timestamp DESC LIMIT 1) AS commission_usd, own_yield_sxt  * (SELECT price_usd FROM sxt.price_history ORDER BY timestamp DESC LIMIT 1) AS own_yield_usd FROM sxt.v_validator_earnings WHERE validator_name = '${validator}' ORDER BY era  -- depends on ${earnings_view}",
              "refId": "A",
              "format": 1,
              "editorType": "sql",
              "queryType": "table"
            }
          ],
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst rawView = (context.grafana && context.grafana.replaceVariables)\n  ? context.grafana.replaceVariables(\"${earnings_view}\")\n  : \"${earnings_view}\";\nconst view = (rawView || \"\").toLowerCase();\nconst isCombined = view === \"combined\" || (view.indexOf(\"sxt\") >= 0 && view.indexOf(\"usd\") >= 0);\nconst showSxt = isCombined || view.indexOf(\"sxt\") >= 0;\nconst showUsd = isCombined || view.indexOf(\"usd\") >= 0;\nconst frame = (context.panel.data.series || [])[0];\nif (!frame || !frame.fields) {\n  return { title: { text: \"No data\", textStyle: { color: \"#A090B5\" }, left: \"center\", top: \"middle\" } };\n}\nconst findField = (name) => frame.fields.find((f) => f.name === name);\nconst xField = findField(\"era\");\nconst xVals  = xField ? (xField.values.buffer || xField.values) : [];\nconst seriesDefs = [];\nif (showSxt) {\n  const c = findField(\"commission_sxt\"); const y = findField(\"own_yield_sxt\");\n  if (c) seriesDefs.push({ name: \"Commission (SXT)\", field: c, color: { type: \"linear\", x: 0, y: 0, x2: 0, y2: 1, colorStops: [{ offset: 0, color: \"#A3308C\" }, { offset: 1, color: \"#5000BF\" }] } });\n  if (y) seriesDefs.push({ name: \"Own yield (SXT)\",  field: y, color: { type: \"linear\", x: 0, y: 0, x2: 0, y2: 1, colorStops: [{ offset: 0, color: \"#7C4DFF\" }, { offset: 1, color: \"#3A1857\" }] } });\n}\nif (showUsd) {\n  const c = findField(\"commission_usd\"); const y = findField(\"own_yield_usd\");\n  if (c) seriesDefs.push({ name: \"Commission (USD)\", field: c, color: { type: \"linear\", x: 0, y: 0, x2: 0, y2: 1, colorStops: [{ offset: 0, color: \"#A3308C\" }, { offset: 1, color: \"#7C4DFF\" }] }, yAxisIndex: 1 });\n  if (y) seriesDefs.push({ name: \"Own yield (USD)\",  field: y, color: { type: \"linear\", x: 0, y: 0, x2: 0, y2: 1, colorStops: [{ offset: 0, color: \"#00BCD4\" }, { offset: 1, color: \"#5000BF\" }] }, yAxisIndex: 1 });\n}\nconst bars = seriesDefs.map((d) => ({\n  name: d.name, type: \"bar\", yAxisIndex: d.yAxisIndex || 0,\n  itemStyle: { color: d.color, borderRadius: [3, 3, 0, 0] },\n  emphasis: { itemStyle: { opacity: 0.85 } },\n  data: (d.field.values.buffer || d.field.values),\n}));\nconst yAxes = [{\n  type: \"value\", scale: true, name: \"SXT\",\n  nameTextStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n  axisLine: { show: false }, axisTick: { show: false },\n  axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n    formatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 2 }) },\n  splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } },\n}];\nif (showUsd) {\n  yAxes.push({ type: \"value\", scale: true, name: \"USD\",\n    nameTextStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    position: \"right\", axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n      formatter: (v) => \"$\" + Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 2 }) },\n    splitLine: { show: false } });\n}\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 70, right: showUsd ? 70 : 20, top: 40, bottom: 60, containLabel: true },\n  legend: { bottom: 0, textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: { trigger: \"axis\", backgroundColor: \"rgba(36, 9, 53, 0.95)\",\n    borderColor: \"#5000BF\", borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\", fontSize: 11 },\n    axisPointer: { type: \"shadow\", shadowStyle: { color: \"rgba(80, 0, 191, 0.1)\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 4 }) },\n  xAxis: { type: \"category\", data: xVals,\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10, rotate: 0 } },\n  yAxis: yAxes, series: bars,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          },
          "description": "Per-era breakdown of commission and own yield, in SXT and USD.\n\nSource: sxt.v_validator_earnings (84 most recent eras)\nDual Y axis: SXT on left, USD on right. Gradients bars by series."
        },
        {
          "title": "Monthly earnings",
          "type": "volkovlabs-echarts-panel",
          "datasource": "ClickHouse",
          "gridPos": {
            "x": 0,
            "y": 23,
            "w": 24,
            "h": 10
          },
          "targets": [
            {
              "rawSql": "SELECT month, comm_sxt, yield_sxt, comm_sxt  * (SELECT price_usd FROM sxt.price_history ORDER BY timestamp DESC LIMIT 1) AS comm_usd, yield_sxt * (SELECT price_usd FROM sxt.price_history ORDER BY timestamp DESC LIMIT 1) AS yield_usd FROM sxt.v_validator_monthly WHERE validator_name = '${validator}' ORDER BY month  -- depends on ${earnings_view}",
              "refId": "A",
              "format": 1,
              "editorType": "sql",
              "queryType": "table"
            }
          ],
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst rawView = (context.grafana && context.grafana.replaceVariables)\n  ? context.grafana.replaceVariables(\"${earnings_view}\")\n  : \"${earnings_view}\";\nconst view = (rawView || \"\").toLowerCase();\nconst isCombined = view === \"combined\" || (view.indexOf(\"sxt\") >= 0 && view.indexOf(\"usd\") >= 0);\nconst showSxt = isCombined || view.indexOf(\"sxt\") >= 0;\nconst showUsd = isCombined || view.indexOf(\"usd\") >= 0;\nconst frame = (context.panel.data.series || [])[0];\nif (!frame || !frame.fields) {\n  return { title: { text: \"No data\", textStyle: { color: \"#A090B5\" }, left: \"center\", top: \"middle\" } };\n}\nconst findField = (name) => frame.fields.find((f) => f.name === name);\nconst xField = findField(\"month\");\nconst xVals  = xField ? (xField.values.buffer || xField.values) : [];\nconst seriesDefs = [];\nif (showSxt) {\n  const c = findField(\"comm_sxt\"); const y = findField(\"yield_sxt\");\n  if (c) seriesDefs.push({ name: \"Commission (SXT)\", field: c, color: { type: \"linear\", x: 0, y: 0, x2: 0, y2: 1, colorStops: [{ offset: 0, color: \"#A3308C\" }, { offset: 1, color: \"#5000BF\" }] } });\n  if (y) seriesDefs.push({ name: \"Own yield (SXT)\",  field: y, color: { type: \"linear\", x: 0, y: 0, x2: 0, y2: 1, colorStops: [{ offset: 0, color: \"#7C4DFF\" }, { offset: 1, color: \"#3A1857\" }] } });\n}\nif (showUsd) {\n  const c = findField(\"comm_usd\"); const y = findField(\"yield_usd\");\n  if (c) seriesDefs.push({ name: \"Commission (USD)\", field: c, color: { type: \"linear\", x: 0, y: 0, x2: 0, y2: 1, colorStops: [{ offset: 0, color: \"#A3308C\" }, { offset: 1, color: \"#7C4DFF\" }] }, yAxisIndex: 1 });\n  if (y) seriesDefs.push({ name: \"Own yield (USD)\",  field: y, color: { type: \"linear\", x: 0, y: 0, x2: 0, y2: 1, colorStops: [{ offset: 0, color: \"#00BCD4\" }, { offset: 1, color: \"#5000BF\" }] }, yAxisIndex: 1 });\n}\nconst bars = seriesDefs.map((d) => ({\n  name: d.name, type: \"bar\", yAxisIndex: d.yAxisIndex || 0,\n  itemStyle: { color: d.color, borderRadius: [3, 3, 0, 0] },\n  emphasis: { itemStyle: { opacity: 0.85 } },\n  data: (d.field.values.buffer || d.field.values),\n}));\nconst yAxes = [{\n  type: \"value\", scale: true, name: \"SXT\",\n  nameTextStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n  axisLine: { show: false }, axisTick: { show: false },\n  axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n    formatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 2 }) },\n  splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } },\n}];\nif (showUsd) {\n  yAxes.push({ type: \"value\", scale: true, name: \"USD\",\n    nameTextStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    position: \"right\", axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n      formatter: (v) => \"$\" + Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 2 }) },\n    splitLine: { show: false } });\n}\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 70, right: showUsd ? 70 : 20, top: 40, bottom: 60, containLabel: true },\n  legend: { bottom: 0, textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: { trigger: \"axis\", backgroundColor: \"rgba(36, 9, 53, 0.95)\",\n    borderColor: \"#5000BF\", borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\", fontSize: 11 },\n    axisPointer: { type: \"shadow\", shadowStyle: { color: \"rgba(80, 0, 191, 0.1)\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 4 }) },\n  xAxis: { type: \"category\", data: xVals,\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10, rotate: 0 } },\n  yAxis: yAxes, series: bars,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          },
          "description": "Monthly aggregates of commission and own yield.\n\nSource: sxt.v_validator_monthly\nUseful for tax/bookkeeping. Select Earnings view (SXT / USD / combined) via toolbar."
        },
        {
          "title": "★ Total stake over time",
          "type": "volkovlabs-echarts-panel",
          "datasource": "ClickHouse",
          "gridPos": {
            "x": 0,
            "y": 33,
            "w": 24,
            "h": 8
          },
          "targets": [
            {
              "rawSql": "SELECT toString(era) AS era, argMax(total_stake, timestamp) AS total_stake FROM sxt.delegation_snapshots WHERE validator_name = '${validator}' GROUP BY era ORDER BY era",
              "refId": "A",
              "format": 1,
              "editorType": "sql",
              "queryType": "table"
            }
          ],
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst frame = (context.panel.data.series || [])[0];\nif (!frame || !frame.fields) {\n  return { title: { text: \"No data\", textStyle: { color: \"#A090B5\" }, left: \"center\", top: \"middle\" } };\n}\nconst eraField = frame.fields.find((f) => f.name === \"era\");\nconst stakeField = frame.fields.find((f) => f.name === \"total_stake\");\nif (!eraField || !stakeField) {\n  return { title: { text: \"Missing era or total_stake column\", textStyle: { color: \"#A090B5\" }, left: \"center\", top: \"middle\" } };\n}\nconst eras   = eraField.values.buffer || eraField.values;\nconst stakes = stakeField.values.buffer || stakeField.values;\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 80, right: 20, top: 20, bottom: 60, containLabel: true },\n  tooltip: { trigger: \"axis\", backgroundColor: \"rgba(36, 9, 53, 0.95)\",\n    borderColor: \"#5000BF\", borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\", fontSize: 11 },\n    axisPointer: { type: \"shadow\", shadowStyle: { color: \"rgba(80, 0, 191, 0.1)\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 0 }) + \" SXT\" },\n  xAxis: { type: \"category\", data: eras, name: \"Era\",\n    nameTextStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    axisLine:  { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10 } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n      formatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 0 }) },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: [{\n    name: \"Total stake\", type: \"bar\", data: stakes,\n    itemStyle: { borderRadius: [3, 3, 0, 0],\n      color: { type: \"linear\", x: 0, y: 0, x2: 0, y2: 1,\n        colorStops: [{ offset: 0, color: \"#CC0AAC\" }, { offset: 1, color: \"#5000BF\" }] } },\n    emphasis: { itemStyle: { opacity: 0.85 } },\n  }],\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          },
          "description": "Per-era snapshot of the validator's total stake, in SXT.\n\nSource: sxt.delegation_snapshots (ClickHouse, argMax by timestamp per era)\nNominator inflow/outflow materializes here as slope changes."
        }
      ],
      "description": "Drill-down by validator (selected via the dropdown above): earnings, commission, own yield, APR, stake history, block production."
    },
    {
      "title": "⬢ This validator",
      "type": "row",
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 4
      },
      "panels": [
        {
          "title": "Validator status",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 1,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_validator_active{address=\"${local_validator}\"}",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">VALIDATOR STATUS</p>{{#if (eq value \"1\")}}<span class=\"sxt-pill\" style=\"background:rgba(0,200,83,0.15); color:#00C853;\"><span class=\"sxt-pill-dot\" style=\"background:#00C853;\"></span>ACTIVE</span>{{else}}<span class=\"sxt-pill\" style=\"background:rgba(255,82,82,0.15); color:#FFB300;\"><span class=\"sxt-pill-dot\" style=\"background:#FFB300;\"></span>WAITING</span>{{/if}}</div><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }.sxt-ratio-status { font-size: 10px; font-weight: 600; margin-top: 2px; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Whether this validator is currently in the active set and producing blocks.\n\nSource: sxt_validator_active{address=${local_validator}}\nGreen 'ACTIVE' = producing. Amber 'WAITING' = bonded but outside the active set."
        },
        {
          "title": "Sync status",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 6,
            "y": 1,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_is_syncing",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">SYNC STATUS</p>{{#if (eq value \"0\")}}<span class=\"sxt-pill\" style=\"background:rgba(0,200,83,0.15); color:#00C853;\"><span class=\"sxt-pill-dot\" style=\"background:#00C853;\"></span>SYNCED</span>{{else}}<span class=\"sxt-pill\" style=\"background:rgba(255,82,82,0.15); color:#FFB300;\"><span class=\"sxt-pill-dot\" style=\"background:#FFB300;\"></span>SYNCING</span>{{/if}}</div><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }.sxt-ratio-status { font-size: 10px; font-weight: 600; margin-top: 2px; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Whether the local SXT node has caught up with the network's best block.\n\nSource: sxt_is_syncing (system_health.isSyncing RPC)\nGreen 'SYNCED' required for correct validation. Amber 'SYNCING' during catch-up."
        },
        {
          "title": "RPC status",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 12,
            "y": 1,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_rpc_up",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">RPC STATUS</p>{{#if (eq value \"1\")}}<span class=\"sxt-pill\" style=\"background:rgba(0,200,83,0.15); color:#00C853;\"><span class=\"sxt-pill-dot\" style=\"background:#00C853;\"></span>ONLINE</span>{{else}}<span class=\"sxt-pill\" style=\"background:rgba(255,82,82,0.15); color:#FF5252;\"><span class=\"sxt-pill-dot\" style=\"background:#FF5252;\"></span>OFFLINE</span>{{/if}}</div><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }.sxt-ratio-status { font-size: 10px; font-weight: 600; margin-top: 2px; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Whether the node's JSON-RPC endpoint is reachable by the exporter.\n\nSource: sxt_rpc_up (1 = reachable, 0 = down)\nRed 'OFFLINE' blocks metric collection. Check systemd and port 9944 locally."
        },
        {
          "title": "Peers",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 18,
            "y": 1,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_peers_count",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">PEERS CONNECTED</p><p class=\"sxt-num sxt-num--md\">{{value}}</p></div><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Count of peers currently connected to the local node.\n\nSource: sxt_peers_count\nHealthy range: 20-50. Below 10 risks missed blocks; above 80 strains the connection pool."
        },
        {
          "title": "Total stake (SXT)",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 5,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_validator_total_stake{address=\"${local_validator}\"}",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">TOTAL STAKE (SXT)</p><p class=\"sxt-num sxt-num--md\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9-]/g,'');if(r){el.textContent=parseInt(r,10).toLocaleString('en-US');}})})();this.remove()\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }.sxt-ratio-status { font-size: 10px; font-weight: 600; margin-top: 2px; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Total SXT bonded to this validator (own stake + nominators).\n\nSource: sxt_validator_total_stake{address=${local_validator}}\nDetermines election priority and reward share within the active set."
        },
        {
          "title": "Total stake (USD)",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 6,
            "y": 5,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_validator_total_stake{address=\"${local_validator}\"} * on() group_left scalar(sxt_token_price_usd)",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">TOTAL STAKE (USD)</p><p class=\"sxt-num sxt-num--md\">$ {{value}}</p></div><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Total stake converted to USD at the current SXT price.\n\nSource: total_stake × sxt_token_price_usd (cross-metric)\nUSD figure for reports; SXT-denominated is more stable."
        },
        {
          "title": "Own stake",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 12,
            "y": 5,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_validator_own_stake{address=\"${local_validator}\"}",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">OWN STAKE</p><p class=\"sxt-num sxt-num--md\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9-]/g,'');if(r){el.textContent=parseInt(r,10).toLocaleString('en-US');}})})();this.remove()\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }.sxt-ratio-status { font-size: 10px; font-weight: 600; margin-top: 2px; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Validator's self-bonded stake, in SXT.\n\nSource: sxt_validator_own_stake{address=${local_validator}}\nOwn stake earns yield at full rate (no commission deducted)."
        },
        {
          "title": "Nominators",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 15,
            "y": 5,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_validator_nominator_count{address=\"${local_validator}\"}",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">NOMINATORS</p><p class=\"sxt-num sxt-num--md\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"(function(){document.querySelectorAll('p[data-raw]').forEach(function(el){var r=el.getAttribute('data-raw').replace(/[^0-9-]/g,'');if(r){el.textContent=parseInt(r,10).toLocaleString('en-US');}})})();this.remove()\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }.sxt-ratio-status { font-size: 10px; font-weight: 600; margin-top: 2px; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Number of unique nominator accounts delegating to this validator.\n\nSource: sxt_validator_nominator_count{address=${local_validator}}\nHigher count = wider trust base."
        },
        {
          "title": "Commission rate",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 18,
            "y": 5,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "sxt_validator_commission{address=\"${local_validator}\"}",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 1
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">COMMISSION</p><p class=\"sxt-num sxt-num--md\">{{value}} %</p></div><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Validator's commission percentage, deducted from nominators' rewards.\n\nSource: sxt_validator_commission{address=${local_validator}}\nSXT network enforces a minimum of 10%."
        },
        {
          "title": "Era points vs avg",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 21,
            "y": 5,
            "w": 3,
            "h": 4
          },
          "targets": [
            {
              "expr": "(sxt_validator_era_points{address=\"${local_validator}\"} / scalar(sxt_staking_era_total_reward_points / sxt_staking_target_validator_count)) * 100",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">VS NETWORK AVG</p><p class=\"sxt-num sxt-num--md\">{{value}} %</p></div><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles",
              "javascript"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Era points earned by this validator as % of the network average for the current era.\n\nSource: era_points / scalar(total_era_points / target_validator_count) × 100\nHealthy ≥95%. Below 85% suggests missed authorship opportunities or slow propagation."
        },
        {
          "title": "Block heights",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 9,
            "w": 8,
            "h": 8
          },
          "targets": [
            {
              "expr": "sxt_block_height_best",
              "refId": "A",
              "legendFormat": "Best",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "sxt_block_height_finalized",
              "refId": "B",
              "legendFormat": "Finalized",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "description": "Best vs finalized block height on the local node, plotted over time.\n\nSource: sxt_block_height_best (BABE) and sxt_block_height_finalized (GRANDPA).\nThe two lines should track closely with a small constant gap. If 'finalized' flatlines while 'best' keeps climbing, GRANDPA is stalling.",
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#5000BF\",\"#CC0AAC\",\"#7C4DFF\",\"#7C4DFF\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 0 }) + \"\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10 },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        },
        {
          "title": "Finality lag",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 8,
            "y": 9,
            "w": 8,
            "h": 8
          },
          "description": "Number of blocks between local 'best' (BABE) and 'finalized' (GRANDPA) tip.\n\nSource: sxt_finality_lag_blocks.\nHealthy: 2-3 blocks. Spikes above 10 suggest GRANDPA round failures, peer issues, or this validator not voting in the current round.",
          "targets": [
            {
              "expr": "sxt_finality_lag_blocks",
              "refId": "A",
              "legendFormat": "Lag",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#CC0AAC\",\"#7C4DFF\",\"#7C4DFF\",\"#7C4DFF\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 0 }) + \" blocks\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10 },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        },
        {
          "title": "Peers over time",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 16,
            "y": 9,
            "w": 8,
            "h": 8
          },
          "targets": [
            {
              "expr": "sxt_peers_count",
              "refId": "A",
              "legendFormat": "Total",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "sxt_peers_authority",
              "refId": "B",
              "legendFormat": "Authority",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "sxt_peers_full",
              "refId": "C",
              "legendFormat": "Full",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "sxt_peers_lagging",
              "refId": "D",
              "legendFormat": "Lagging",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "description": "Breakdown of peers connected to the local node over time.\n\nSource: sxt_peers_count / authority / full / lagging.\n'Authority' peers are other active validators (most relevant for consensus). 'Lagging' = peers still syncing that we're helping.",
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#5000BF\",\"#CC0AAC\",\"#00BCD4\",\"#FFB300\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 0 }) + \"\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10 },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        },
        {
          "title": "Block proposal time",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 17,
            "w": 8,
            "h": 8
          },
          "targets": [
            {
              "expr": "rate(substrate_proposer_block_proposal_time_sum{job=\"sxt-node\"}[5m]) / rate(substrate_proposer_block_proposal_time_count{job=\"sxt-node\"}[5m])",
              "refId": "A",
              "legendFormat": "Avg",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "histogram_quantile(0.99, rate(substrate_proposer_block_proposal_time_bucket{job=\"sxt-node\"}[5m]))",
              "refId": "B",
              "legendFormat": "p99",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "description": "Time the local node takes to construct a new block (average and p99).\n\nSource: substrate_proposer_block_proposal_time_* histogram.\nHealthy: <500ms average. Slow proposals risk missing BABE slots and earning fewer era points.",
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#5000BF\",\"#CC0AAC\",\"#7C4DFF\",\"#7C4DFF\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 3 }) + \" s\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10 },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        },
        {
          "title": "Block import time",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 8,
            "y": 17,
            "w": 8,
            "h": 8
          },
          "targets": [
            {
              "expr": "rate(substrate_block_verification_and_import_time_sum{job=\"sxt-node\"}[5m]) / rate(substrate_block_verification_and_import_time_count{job=\"sxt-node\"}[5m])",
              "refId": "A",
              "legendFormat": "Avg",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "histogram_quantile(0.99, rate(substrate_block_verification_and_import_time_bucket{job=\"sxt-node\"}[5m]))",
              "refId": "B",
              "legendFormat": "p99",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "description": "Time to verify and import a block received from peers (average and p99).\n\nSource: substrate_block_verification_and_import_time_* histogram.\nHealthy: <1s average. Slow imports indicate CPU or disk I/O bottlenecks; can cause the node to fall behind consensus.",
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#5000BF\",\"#CC0AAC\",\"#7C4DFF\",\"#7C4DFF\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 3 }) + \" s\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10 },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        },
        {
          "title": "Network bandwidth",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 16,
            "y": 17,
            "w": 8,
            "h": 8
          },
          "targets": [
            {
              "expr": "rate(substrate_sub_libp2p_network_bytes_total{direction=\"in\",job=\"sxt-node\"}[5m])",
              "refId": "A",
              "legendFormat": "In",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "rate(substrate_sub_libp2p_network_bytes_total{direction=\"out\",job=\"sxt-node\"}[5m])",
              "refId": "B",
              "legendFormat": "Out",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "description": "Inbound and outbound libp2p traffic at the substrate node process level.\n\nSource: rate(substrate_sub_libp2p_network_bytes_total[5m]).\nThis is the node's process-level traffic; compare with Host machine → Network I/O for host-wide context.",
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#5000BF\",\"#CC0AAC\",\"#7C4DFF\",\"#7C4DFF\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => (Number(v)/1024).toLocaleString(\"en-US\", { maximumFractionDigits: 1 }) + \" KB/s\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10, formatter: (v) => (v/1024).toFixed(0) + \" KB/s\" },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        }
      ],
      "description": "Metrics from the local node we are connected to: peers, BABE/GRANDPA health, proposal & import times, bandwidth, gossip."
    },
    {
      "title": "⬢ Host machine",
      "type": "row",
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 5
      },
      "panels": [
        {
          "title": "Host status",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 1,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "up{instance=\"sxt-validator-host\",job=\"node-exporter\"}",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">HOST STATUS</p><span class=\"sxt-pill sxt-pill-host\" data-raw=\"{{value}}\"><span class=\"sxt-pill-dot\"></span><span class=\"sxt-pill-text\">—</span></span></div><img src=\"x\" onerror=\"document.querySelectorAll('span.sxt-pill-host').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));var dot=el.querySelector('.sxt-pill-dot');var txt=el.querySelector('.sxt-pill-text');if(isNaN(n)){txt.textContent='—';return;}var state=(!(n &gt;= 1))?'bad':((false)?'warn':'ok');var cfg={ok:{t:'UP',c:'#00C853',bg:'rgba(0,200,83,0.15)'},warn:{t:'—',c:'#FFB300',bg:'rgba(255,179,0,0.15)'},bad:{t:'DOWN',c:'#FF5252',bg:'rgba(255,82,82,0.15)'}};var c=cfg[state];txt.textContent=c.t;dot.style.background=c.c;el.style.color=c.c;el.style.background=c.bg;})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Whether node_exporter is reachable by Prometheus on the host.\n\nSource: up{instance='sxt-validator-host',job='node-exporter'}\nRed 'DOWN' means the entire host-level monitoring is blind."
        },
        {
          "title": "Disk health",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 6,
            "y": 1,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "(1 - (node_filesystem_avail_bytes{instance=\"sxt-validator-host\",mountpoint=\"$disk_mount\"} / node_filesystem_size_bytes{instance=\"sxt-validator-host\",mountpoint=\"$disk_mount\"})) * 100",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">DISK /sxt-data</p><span class=\"sxt-pill sxt-pill-disk\" data-raw=\"{{value}}\"><span class=\"sxt-pill-dot\"></span><span class=\"sxt-pill-text\">—</span></span></div><img src=\"x\" onerror=\"document.querySelectorAll('span.sxt-pill-disk').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));var dot=el.querySelector('.sxt-pill-dot');var txt=el.querySelector('.sxt-pill-text');if(isNaN(n)){txt.textContent='—';return;}var state=(n &gt;= 90)?'bad':((n &gt;= 80)?'warn':'ok');var cfg={ok:{t:'HEALTHY',c:'#00C853',bg:'rgba(0,200,83,0.15)'},warn:{t:'WARNING',c:'#FFB300',bg:'rgba(255,179,0,0.15)'},bad:{t:'CRITICAL',c:'#FF5252',bg:'rgba(255,82,82,0.15)'}};var c=cfg[state];txt.textContent=c.t;dot.style.background=c.c;el.style.color=c.c;el.style.background=c.bg;})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Used-space health on /sxt-data (the validator DB partition).\n\nSource: (1 - avail / size) × 100 on mountpoint='/sxt-data'\nGreen <80%, amber 80-90%, red ≥90%. Critical at 95% (risk of DB halt)."
        },
        {
          "title": "Memory health",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 12,
            "y": 1,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "(1 - (node_memory_MemAvailable_bytes{instance=\"sxt-validator-host\"} / node_memory_MemTotal_bytes{instance=\"sxt-validator-host\"})) * 100",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">MEMORY</p><span class=\"sxt-pill sxt-pill-memory\" data-raw=\"{{value}}\"><span class=\"sxt-pill-dot\"></span><span class=\"sxt-pill-text\">—</span></span></div><img src=\"x\" onerror=\"document.querySelectorAll('span.sxt-pill-memory').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));var dot=el.querySelector('.sxt-pill-dot');var txt=el.querySelector('.sxt-pill-text');if(isNaN(n)){txt.textContent='—';return;}var state=(n &gt;= 90)?'bad':((n &gt;= 80)?'warn':'ok');var cfg={ok:{t:'HEALTHY',c:'#00C853',bg:'rgba(0,200,83,0.15)'},warn:{t:'WARNING',c:'#FFB300',bg:'rgba(255,179,0,0.15)'},bad:{t:'PRESSURE',c:'#FF5252',bg:'rgba(255,82,82,0.15)'}};var c=cfg[state];txt.textContent=c.t;dot.style.background=c.c;el.style.color=c.c;el.style.background=c.bg;})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Memory pressure health on the host.\n\nSource: (1 - MemAvailable / MemTotal) × 100\nGreen <80%, amber 80-90%, red ≥90%. Includes cache/buffers as 'available'."
        },
        {
          "title": "Load health",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 18,
            "y": 1,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "node_load1{instance=\"sxt-validator-host\"} / scalar(count(count(node_cpu_seconds_total{instance=\"sxt-validator-host\"}) by (cpu)))",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">SYSTEM LOAD</p><span class=\"sxt-pill sxt-pill-load\" data-raw=\"{{value}}\"><span class=\"sxt-pill-dot\"></span><span class=\"sxt-pill-text\">—</span></span></div><img src=\"x\" onerror=\"document.querySelectorAll('span.sxt-pill-load').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));var dot=el.querySelector('.sxt-pill-dot');var txt=el.querySelector('.sxt-pill-text');if(isNaN(n)){txt.textContent='—';return;}var state=(n &gt;= 2)?'bad':((n &gt;= 1)?'warn':'ok');var cfg={ok:{t:'HEALTHY',c:'#00C853',bg:'rgba(0,200,83,0.15)'},warn:{t:'ELEVATED',c:'#FFB300',bg:'rgba(255,179,0,0.15)'},bad:{t:'OVERLOADED',c:'#FF5252',bg:'rgba(255,82,82,0.15)'}};var c=cfg[state];txt.textContent=c.t;dot.style.background=c.c;el.style.color=c.c;el.style.background=c.bg;})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "System load normalized per CPU core.\n\nSource: node_load1 / scalar(cpu_count)\nGreen <1 (CPUs idle enough), amber 1-2 (saturation), red ≥2 (overload)."
        },
        {
          "title": "CPU usage",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 5,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "(1 - avg by (instance) (rate(node_cpu_seconds_total{instance=\"sxt-validator-host\",mode=\"idle\"}[1m]))) * 100",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">CPU USAGE</p><p class=\"sxt-num sxt-num--md sxt-fmt-pct\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-pct').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));if(isNaN(n) &amp;&amp; n &gt;= 0){el.textContent='—';return;}el.textContent=n.toFixed(1)+' %';el.style.color=(n &lt; 80)?'#E6E6E6':((n &lt; 90)?'#FFB300':'#FF5252');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Current CPU utilization across all cores.\n\nSource: (1 - avg rate of mode='idle') × 100\nSubstrate nodes typically sit at 5-20%. Sustained >70% warrants investigation."
        },
        {
          "title": "RAM used",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 4,
            "y": 5,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "(1 - (node_memory_MemAvailable_bytes{instance=\"sxt-validator-host\"} / node_memory_MemTotal_bytes{instance=\"sxt-validator-host\"})) * 100",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">RAM USED</p><p class=\"sxt-num sxt-num--md sxt-fmt-pct\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-pct').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));if(isNaN(n) &amp;&amp; n &gt;= 0){el.textContent='—';return;}el.textContent=n.toFixed(1)+' %';el.style.color=(n &lt; 80)?'#E6E6E6':((n &lt; 90)?'#FFB300':'#FF5252');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "RAM utilization as percent of total.\n\nSource: (1 - MemAvailable / MemTotal) × 100\nLinux aggressively caches filesystem data; 50-70% steady is normal."
        },
        {
          "title": "Disk used",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 8,
            "y": 5,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "(1 - (node_filesystem_avail_bytes{instance=\"sxt-validator-host\",mountpoint=\"$disk_mount\"} / node_filesystem_size_bytes{instance=\"sxt-validator-host\",mountpoint=\"$disk_mount\"})) * 100",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">DISK /sxt-data</p><p class=\"sxt-num sxt-num--md sxt-fmt-pct\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-pct').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));if(isNaN(n) &amp;&amp; n &gt;= 0){el.textContent='—';return;}el.textContent=n.toFixed(1)+' %';el.style.color=(n &lt; 80)?'#E6E6E6':((n &lt; 90)?'#FFB300':'#FF5252');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Used space on /sxt-data as percent of the partition.\n\nSource: (1 - avail / size) × 100 on mountpoint='/sxt-data'\nChain state grows continuously. Plan pruning or expansion at 85%."
        },
        {
          "title": "Network RX",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 12,
            "y": 5,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "sum(rate(node_network_receive_bytes_total{instance=\"sxt-validator-host\",device=~\"enp.*\"}[1m]))",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">NET RX</p><p class=\"sxt-num sxt-num--md sxt-fmt-bytes\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-bytes').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));if(isNaN(n) &amp;&amp; n &gt;= 0){el.textContent='—';return;}var mb=n/1048576;el.textContent=(mb &gt;= 1)?(mb.toFixed(1)+' MB/s'):((n/1024).toFixed(0)+' KB/s');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Inbound network traffic across physical NICs.\n\nSource: sum of rate(node_network_receive_bytes_total{device=~'enp.*'}) over 1m\nMostly p2p gossip and block propagation. Spikes can correlate with reorgs."
        },
        {
          "title": "Network TX",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 16,
            "y": 5,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "sum(rate(node_network_transmit_bytes_total{instance=\"sxt-validator-host\",device=~\"enp.*\"}[1m]))",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">NET TX</p><p class=\"sxt-num sxt-num--md sxt-fmt-bytes\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-bytes').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));if(isNaN(n) &amp;&amp; n &gt;= 0){el.textContent='—';return;}var mb=n/1048576;el.textContent=(mb &gt;= 1)?(mb.toFixed(1)+' MB/s'):((n/1024).toFixed(0)+' KB/s');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Outbound network traffic across physical NICs.\n\nSource: sum of rate(node_network_transmit_bytes_total{device=~'enp.*'}) over 1m\nHigher for active authorities (broadcasting blocks + GRANDPA votes)."
        },
        {
          "title": "Uptime",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 20,
            "y": 5,
            "w": 4,
            "h": 4
          },
          "targets": [
            {
              "expr": "(time() - node_boot_time_seconds{instance=\"sxt-validator-host\"})",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">UPTIME</p><p class=\"sxt-num sxt-num--md sxt-fmt-uptime\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-uptime').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));if(isNaN(n) &amp;&amp; n &gt;= 0){el.textContent='—';return;}var d=Math.floor(n/86400),h=Math.floor((n%86400)/3600),m=Math.floor((n%3600)/60);el.textContent=(d &gt; 0?d+'d ':'')+h+'h '+m+'m';})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Time since last host boot.\n\nSource: time() - node_boot_time_seconds\nLong uptimes are good for availability metrics but kernel updates eventually require reboot."
        },
        {
          "title": "CPU cores",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 9,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "count(count(node_cpu_seconds_total{instance=\"sxt-validator-host\"}) by (cpu))",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">CPU CORES</p><p class=\"sxt-num sxt-num--md\">{{value}}</p></div><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Number of logical CPU cores on the host.\n\nSource: count of unique 'cpu' labels in node_cpu_seconds_total\nIncludes hyperthreaded siblings if present."
        },
        {
          "title": "RAM total",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 6,
            "y": 9,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "node_memory_MemTotal_bytes{instance=\"sxt-validator-host\"} / 1073741824",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">RAM TOTAL</p><p class=\"sxt-num sxt-num--md sxt-fmt-gb\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-gb').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));if(isNaN(n) &amp;&amp; n &gt;= 0){el.textContent='—';return;}el.textContent=Math.round(n).toLocaleString('en-US')+' GB';})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Total installed RAM in the host.\n\nSource: node_memory_MemTotal_bytes / 1 GiB\nSubstrate nodes benefit from 32+ GB; 64 GB is comfortable for validators."
        },
        {
          "title": "Disk total",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 12,
            "y": 9,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "node_filesystem_size_bytes{instance=\"sxt-validator-host\",mountpoint=\"$disk_mount\"} / 1073741824",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">DISK TOTAL</p><p class=\"sxt-num sxt-num--md sxt-fmt-gb\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-gb').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));if(isNaN(n) &amp;&amp; n &gt;= 0){el.textContent='—';return;}el.textContent=Math.round(n).toLocaleString('en-US')+' GB';})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Total capacity of /sxt-data partition.\n\nSource: node_filesystem_size_bytes{mountpoint='/sxt-data'} / 1 GiB\nPlanning figure for chain growth estimates."
        },
        {
          "title": "CPU temp",
          "type": "marcusolsson-dynamictext-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 18,
            "y": 9,
            "w": 6,
            "h": 4
          },
          "targets": [
            {
              "expr": "avg(node_hwmon_temp_celsius{instance=\"sxt-validator-host\"})",
              "refId": "A",
              "legendFormat": "",
              "format": "time_series",
              "instant": true,
              "range": false
            }
          ],
          "transformations": [
            {
              "id": "renameByRegex",
              "options": {
                "regex": "^(?!Time$).*",
                "renamePattern": "value"
              }
            }
          ],
          "fieldConfig": {
            "defaults": {
              "unit": "none",
              "decimals": 0
            },
            "overrides": []
          },
          "options": {
            "content": "<div class=\"sxt-card sxt-card--centered\"><p class=\"sxt-label\">CPU TEMP</p><p class=\"sxt-num sxt-num--md sxt-fmt-temp\" data-raw=\"{{value}}\">{{value}}</p></div><img src=\"x\" onerror=\"document.querySelectorAll('p.sxt-fmt-temp').forEach(function(el){var n=parseFloat(el.getAttribute('data-raw'));if(isNaN(n) &amp;&amp; n &gt;= 0){el.textContent='—';return;}el.textContent=n.toFixed(0)+' °C';el.style.color=(n &lt; 70)?'#E6E6E6':((n &lt; 85)?'#FFB300':'#FF5252');})\" style=\"display:none\"><style>.sxt-card--centered { display:flex; flex-direction:column; align-items:center; justify-content:center; text-align:center; gap:6px; height:100%; }.sxt-card--centered .sxt-label, .sxt-card--centered .sxt-num { margin:0; }.sxt-pill { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:12px; font-weight:600; font-size:11px; }.sxt-pill-dot { width:8px; height:8px; border-radius:50%; }</style>",
            "defaultContent": "",
            "everyRow": true,
            "renderMode": "everyRow",
            "wrap": true,
            "editors": [
              "text",
              "styles"
            ],
            "externalStyles": [],
            "helpers": "",
            "javascript": {
              "afterRender": "",
              "beforeRender": ""
            },
            "status": {
              "handler": "",
              "thresholds": []
            },
            "styles": "",
            "contentPartials": []
          },
          "description": "Average CPU temperature across hwmon sensors.\n\nSource: avg of node_hwmon_temp_celsius\nGreen <70°C, amber 70-85°C, red ≥85°C (thermal throttling risk)."
        },
        {
          "title": "CPU over time",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 13,
            "w": 8,
            "h": 8
          },
          "targets": [
            {
              "expr": "(sum by (mode) (rate(node_cpu_seconds_total{instance=\"sxt-validator-host\",mode!=\"idle\"}[1m])) / scalar(count(count(node_cpu_seconds_total{instance=\"sxt-validator-host\"}) by (cpu)))) * 100",
              "refId": "A",
              "legendFormat": "{{mode}}",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "description": "CPU time by mode (user, system, iowait, etc), normalized by core count.",
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#5000BF\",\"#CC0AAC\",\"#00BCD4\",\"#FFB300\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 2 }) + \" %\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n      formatter: (v) => Number(v).toFixed(0) + \" %\" },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        },
        {
          "title": "Memory over time",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 8,
            "y": 13,
            "w": 8,
            "h": 8
          },
          "targets": [
            {
              "expr": "(node_memory_MemTotal_bytes{instance=\"sxt-validator-host\"} - node_memory_MemAvailable_bytes{instance=\"sxt-validator-host\"}) / 1073741824",
              "refId": "A",
              "legendFormat": "Used",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "node_memory_Cached_bytes{instance=\"sxt-validator-host\"} / 1073741824",
              "refId": "B",
              "legendFormat": "Cached",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "node_memory_Buffers_bytes{instance=\"sxt-validator-host\"} / 1073741824",
              "refId": "C",
              "legendFormat": "Buffers",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "node_memory_MemFree_bytes{instance=\"sxt-validator-host\"} / 1073741824",
              "refId": "D",
              "legendFormat": "Free",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "description": "Memory breakdown in GB.",
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#CC0AAC\",\"#5000BF\",\"#00BCD4\",\"#4CAF50\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 2 }) + \" GB\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n      formatter: (v) => Number(v).toFixed(0) + \" GB\" },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        },
        {
          "title": "Load average",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 16,
            "y": 13,
            "w": 8,
            "h": 8
          },
          "targets": [
            {
              "expr": "node_load1{instance=\"sxt-validator-host\"}",
              "refId": "A",
              "legendFormat": "1m",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "node_load5{instance=\"sxt-validator-host\"}",
              "refId": "B",
              "legendFormat": "5m",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "node_load15{instance=\"sxt-validator-host\"}",
              "refId": "C",
              "legendFormat": "15m",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "description": "System load averaged over 1 / 5 / 15 minutes.",
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#CC0AAC\",\"#5000BF\",\"#00BCD4\",\"#7C4DFF\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 2 }) + \"\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n      formatter: (v) => Number(v).toFixed(2) },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        },
        {
          "title": "Disk I/O",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 0,
            "y": 21,
            "w": 12,
            "h": 8
          },
          "targets": [
            {
              "expr": "rate(node_disk_read_bytes_total{instance=\"sxt-validator-host\",device=~\"md[34]\"}[1m])",
              "refId": "A",
              "legendFormat": "{{device}} read",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "rate(node_disk_written_bytes_total{instance=\"sxt-validator-host\",device=~\"md[34]\"}[1m])",
              "refId": "B",
              "legendFormat": "{{device}} write",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "description": "Read/write throughput per RAID device (md3 = root, md4 = /sxt-data).",
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#5000BF\",\"#CC0AAC\",\"#00BCD4\",\"#FFB300\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 2 }) + \" MB/s\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n      formatter: (v) => (v/1048576).toFixed(0) + \" MB/s\" },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        },
        {
          "title": "Network I/O",
          "type": "volkovlabs-echarts-panel",
          "datasource": "Prometheus",
          "gridPos": {
            "x": 12,
            "y": 21,
            "w": 12,
            "h": 8
          },
          "targets": [
            {
              "expr": "rate(node_network_receive_bytes_total{instance=\"sxt-validator-host\",device=~\"enp.*\"}[1m])",
              "refId": "A",
              "legendFormat": "{{device}} RX",
              "format": "time_series",
              "instant": false,
              "range": true
            },
            {
              "expr": "rate(node_network_transmit_bytes_total{instance=\"sxt-validator-host\",device=~\"enp.*\"}[1m])",
              "refId": "B",
              "legendFormat": "{{device}} TX",
              "format": "time_series",
              "instant": false,
              "range": true
            }
          ],
          "description": "RX/TX bandwidth per physical NIC.",
          "fieldConfig": {
            "defaults": {},
            "overrides": []
          },
          "options": {
            "getOption": "\nconst palette = [\"#5000BF\",\"#CC0AAC\",\"#00BCD4\",\"#FFB300\"];\nconst series = [];\n(context.panel.data.series || []).forEach((s, i) => {\n  const numField = s.fields.find((f) => f.type === \"number\");\n  const timeField = s.fields.find((f) => f.type === \"time\");\n  if (!numField || !timeField) return;\n  const values = numField.values.buffer || numField.values;\n  const times  = timeField.values.buffer || timeField.values;\n  if (!values || !times || values.length === 0) return;\n  const points = [];\n  for (let k = 0; k < times.length; k++) {\n    const v = values[k];\n    if (v === null || v === undefined || Number.isNaN(v)) continue;\n    points.push([times[k], v]);\n  }\n  if (points.length === 0) return;\n  const lbl = (numField.config && numField.config.displayNameFromDS) || s.name || (\"series-\" + i);\n  const color = palette[series.length % palette.length];\n  series.push({ name: lbl, type: \"line\", smooth: true, showSymbol: false,\n    lineStyle: { width: 1.8, color: color }, itemStyle: { color: color },\n    emphasis: { focus: \"series\", lineStyle: { width: 2.8 } }, data: points });\n});\n\nreturn {\n  backgroundColor: \"transparent\",\n  grid: { left: 60, right: 20, top: 30, bottom: 60, containLabel: true },\n  legend: { type: \"scroll\", bottom: 0,\n    textStyle: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 } },\n  tooltip: {\n    trigger: \"axis\",\n    backgroundColor: \"rgba(36, 9, 53, 0.97)\",\n    borderColor: \"#5000BF\",\n    borderWidth: 1,\n    textStyle: { color: \"#E6E6E6\", fontFamily: \"Inter, sans-serif\" },\n    axisPointer: { lineStyle: { color: \"#5000BF\", type: \"dashed\" } },\n    valueFormatter: (v) => Number(v).toLocaleString(\"en-US\", { maximumFractionDigits: 2 }) + \" MB/s\"\n  },\n  xAxis: { type: \"time\",\n    axisLine: { lineStyle: { color: \"#3A1857\" } },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"Inter\", fontSize: 10 },\n    splitLine: { show: false } },\n  yAxis: { type: \"value\", scale: true,\n    axisLine: { show: false }, axisTick: { show: false },\n    axisLabel: { color: \"#A090B5\", fontFamily: \"JetBrains Mono\", fontSize: 10,\n      formatter: (v) => (v/1048576).toFixed(1) + \" MB/s\" },\n    splitLine: { lineStyle: { color: \"rgba(58, 24, 87, 0.4)\", type: \"dashed\" } } },\n  series: series,\n};\n",
            "renderer": "canvas",
            "themeEditor": {
              "name": "default"
            },
            "visualEditor": {
              "code": "",
              "codeOptions": {},
              "dataset": [],
              "series": []
            },
            "editor": {
              "format": "auto",
              "height": 600
            },
            "map": ""
          }
        }
      ],
      "description": "Hardware and OS resources of the VPS hosting the node: CPU, RAM, disk, I/O, network."
    }
  ],
  "id": null,
  "editable": true,
  "templating": {
    "list": [
      {
        "name": "validator",
        "type": "query",
        "datasource": "Prometheus",
        "query": "label_values(sxt_validator_total_stake, address)",
        "current": {
          "text": "",
          "value": ""
        },
        "refresh": 2,
        "hide": 0,
        "includeAll": false,
        "regex": ""
      },
      {
        "name": "disk_mount",
        "type": "custom",
        "query": "__SXT_DATA_MOUNTPOINT__",
        "current": {
          "text": "__SXT_DATA_MOUNTPOINT__",
          "value": "__SXT_DATA_MOUNTPOINT__"
        },
        "hide": 2,
        "description": "Mountpoint for disk usage gauge — override in dashboard settings"
      },
      {
        "name": "earnings_view",
        "type": "custom",
        "label": "Earnings",
        "query": "combined : _sxt|_usd,sxt : _sxt,usd : _usd",
        "current": {
          "text": "combined",
          "value": "_sxt|_usd",
          "selected": true
        },
        "options": [
          {
            "text": "combined",
            "value": "_sxt|_usd",
            "selected": true
          },
          {
            "text": "sxt",
            "value": "_sxt",
            "selected": false
          },
          {
            "text": "usd",
            "value": "_usd",
            "selected": false
          }
        ],
        "hide": 0
      },
      {
        "name": "local_validator",
        "type": "constant",
        "label": null,
        "hide": 2,
        "query": "__SXT_LOCAL_VALIDATOR__",
        "skipUrlSync": true,
        "current": {
          "selected": false,
          "text": "__SXT_LOCAL_VALIDATOR__",
          "value": "__SXT_LOCAL_VALIDATOR__"
        },
        "options": [
          {
            "selected": true,
            "text": "__SXT_LOCAL_VALIDATOR__",
            "value": "__SXT_LOCAL_VALIDATOR__"
          }
        ]
      }
    ]
  }
}