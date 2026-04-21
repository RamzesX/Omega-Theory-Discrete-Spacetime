// ============================================================
// subsystem_hub_shannon_entropy_v1.cypher
// ------------------------------------------------------------
// Recipe: Shannon entropy of per-relation in-degree mass, per
//         SubsystemNavigator (OmegaTheoryV2).
//
// Author  : Procyon (grothendieck-sage, 2026-04-19)
// Runtime : ~15 s on the 12.8K-node OmegaTheoryV2 corpus
// Outputs : SubsystemNavigator.hub_shannon_entropy   (float)
//           SubsystemNavigator.hub_total_mass        (int)
//           SubsystemNavigator.hub_top_rel           (string)
//           SubsystemNavigator.hub_top_rel_share     (float in [0,1])
//           SubsystemNavigator.hub_entropy_source    ('live_indegree_v1')
//
// Rationale:
//   Each SubsystemNavigator aggregates a Leiden community over
//   the OmegaTheoryV2 Lean corpus. Typed inbound edges
//   (APPLIES, UNFOLDS, REWRITES_BY, PARAMETRIZES, HAS_TYPE,
//    ASSUMES, SPECIALIZES) can be read as a 7-channel
//   "attention" profile of how the subsystem is used by the
//   rest of the theory. Shannon entropy of the normalised
//   channel masses measures proof-modality pluralism:
//     * H ~ 0       => DICTATOR-HUB  (one arrow type >90%)
//     * H ~ log(7)  => DEMOCRACY-HUB (balanced across arrows)
//
// NOTE on data source (2026-04-19):
//   The precomputed hub_score_<REL> properties are stale
//   post-SOTA upgrade (only 41/8293 theorems populated, all
//   zero). We therefore read live in-degrees directly from
//   the edge catalogue; this is the authoritative signal and
//   incurs no dependency on the (slow) Phase-K refresh.
// ============================================================

// Persist the recipe (idempotent)
MERGE (r:GrothendieckRecipe {
  namespace: 'OmegaTheoryV2',
  name:      'subsystem_hub_shannon_entropy_v1'
})
  ON CREATE SET r.created_by  = 'Procyon',
                r.created_at  = datetime()
SET r.phase                 = 'Z1-novel',
    r.rationale             = 'Shannon entropy of inbound typed-edge mass per subsystem. Measures proof-modality pluralism.',
    r.produces              = 'SubsystemNavigator.{hub_shannon_entropy, hub_total_mass, hub_top_rel, hub_top_rel_share, hub_entropy_source}',
    r.estimated_runtime_sec = 15,
    r.relations_used        = ['APPLIES','UNFOLDS','REWRITES_BY','PARAMETRIZES','HAS_TYPE','ASSUMES','SPECIALIZES'];

// ------------------------------------------------------------
// Body: compute entropy on every :SubsystemNavigator
// ------------------------------------------------------------
MATCH (s:SubsystemNavigator {namespace:'OmegaTheoryV2'})-[:CONTAINS]->(n)
WHERE n.namespace = 'OmegaTheoryV2'
CALL {
  WITH n
  MATCH (m)-[r]->(n)
  WHERE m.namespace = 'OmegaTheoryV2'
    AND type(r) IN ['APPLIES','UNFOLDS','REWRITES_BY','PARAMETRIZES','HAS_TYPE','ASSUMES','SPECIALIZES']
  RETURN type(r) AS rel, count(*) AS k
}
WITH s, rel, sum(k) AS mass
WITH s, collect({rel: rel, mass: mass}) AS dist, sum(mass) AS Z
WITH s, Z, dist,
     reduce(mx=0.0, x IN dist |
            CASE WHEN x.mass > mx THEN toFloat(x.mass) ELSE mx END) AS max_mass
WITH s, Z, dist, max_mass,
     [d IN dist WHERE Z > 0 | toFloat(d.mass) / toFloat(Z)] AS p
WITH s, Z, dist, max_mass, p,
     reduce(H=0.0, q IN p |
            H - (CASE WHEN q > 0 THEN q * log(q) ELSE 0.0 END)) AS H
WITH s, H, Z, max_mass,
     head([d IN dist WHERE Z > 0 AND toFloat(d.mass) = max_mass | d.rel]) AS top_rel,
     (CASE WHEN Z > 0 THEN max_mass / toFloat(Z) ELSE 0.0 END) AS top_share
SET s.hub_shannon_entropy = H,
    s.hub_total_mass      = toInteger(Z),
    s.hub_top_rel         = top_rel,
    s.hub_top_rel_share   = top_share,
    s.hub_entropy_source  = 'live_indegree_v1'
RETURN count(s) AS navigators_updated;

// ------------------------------------------------------------
// Inspection queries
// ------------------------------------------------------------
// (a) Democracies (H highest, mass >= 20)
//   MATCH (s:SubsystemNavigator {namespace:'OmegaTheoryV2'})
//   WHERE s.hub_total_mass >= 20
//   RETURN s.subsystem_id, s.hub_shannon_entropy, s.hub_top_rel, s.hub_top_rel_share
//   ORDER BY s.hub_shannon_entropy DESC LIMIT 5;
//
// (b) Dictators (H lowest, mass >= 20)
//   MATCH (s:SubsystemNavigator {namespace:'OmegaTheoryV2'})
//   WHERE s.hub_total_mass >= 20
//   RETURN s.subsystem_id, s.hub_shannon_entropy, s.hub_top_rel, s.hub_top_rel_share
//   ORDER BY s.hub_shannon_entropy ASC LIMIT 5;
//
// (c) Dominant-relation census
//   MATCH (s:SubsystemNavigator {namespace:'OmegaTheoryV2'})
//   WHERE s.hub_top_rel IS NOT NULL
//   RETURN s.hub_top_rel, count(*) AS n,
//          avg(s.hub_shannon_entropy) AS avg_H,
//          avg(s.hub_top_rel_share)   AS avg_share
//   ORDER BY n DESC;
