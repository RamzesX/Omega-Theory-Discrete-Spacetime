#!/usr/bin/env python3
from neo4j import GraphDatabase

driver = GraphDatabase.driver('bolt://localhost:7687', auth=('neo4j', 'omegatheory2026'))
with driver.session() as session:
    for rec in session.run("MATCH (n) WHERE n.namespace='OmegaTheoryV2' RETURN labels(n)[0] AS label, count(n) AS count ORDER BY count DESC"):
        print(f"{rec['label']:25s} {rec['count']}")
    print('--- rels ---')
    for rec in session.run("MATCH (a {namespace:'OmegaTheoryV2'})-[r]->(b) RETURN type(r) AS rel, count(*) AS count ORDER BY count DESC"):
        print(f"{rec['rel']:25s} {rec['count']}")
driver.close()
