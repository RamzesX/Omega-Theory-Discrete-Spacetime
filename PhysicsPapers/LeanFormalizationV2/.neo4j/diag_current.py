#!/usr/bin/env python3
from neo4j import GraphDatabase

driver = GraphDatabase.driver('bolt://localhost:7687', auth=('neo4j', 'omegatheory2026'))
with driver.session() as session:
    print('== Existing Theorems in OmegaTheoryV2 ==')
    for rec in session.run("MATCH (t:Theorem {namespace:'OmegaTheoryV2'}) RETURN t.name AS name, t.file AS file ORDER BY t.name"):
        print(f"  {rec['name']:60s}  file={rec['file']}")

    print('\n== Existing LeanFiles ==')
    for rec in session.run("MATCH (f:LeanFile {namespace:'OmegaTheoryV2'}) RETURN f.path AS path, f.role AS role ORDER BY f.path"):
        print(f"  {rec['path']:70s} role={rec['role']}")

    print('\n== Axioms ==')
    for rec in session.run("MATCH (a:Axiom {namespace:'OmegaTheoryV2'}) RETURN a.name AS name ORDER BY a.name"):
        print(f"  {rec['name']}")
driver.close()
